import cookie from 'cookie'
import { decode } from 'jsonwebtoken'
import { helpers } from 'vuelidate/lib/validators'

import AUTHENTICATE_MUTATION from '~/gql/mutation/authenticate'
import JWT_REFRESH_MUTATION from '~/gql/mutation/jwtRefresh'

const consola = require('consola')

export const ITEMS_PER_PAGE = 8
export const REGEX_SLUG = /^[-A-Za-z0-9]+$/
export const REGEX_UUID = /^[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}$/
export const VERIFICATION_FORMAT_SLUG = helpers.regex('slug', REGEX_SLUG)
export const VERIFICATION_FORMAT_UUID = helpers.regex('uuid', REGEX_UUID)

export async function authenticateAnonymous(apolloClient, store, res) {
  consola.trace('Authenticating anonymously...')

  const authenticationData = await apolloClient
    .mutate({
      mutation: AUTHENTICATE_MUTATION,
      variables: {
        participationCode: undefined,
      },
    })
    .then(({ data }) => getNested(data, 'authenticate'))
    .catch((error) => {
      consola.error(error)
    })

  if (!authenticationData) {
    consola.warn('No authentication data!')
    return
  }

  await storeJwt(apolloClient, store, res, authenticationData.jwt)
}

export function capitalizeFirstLetter(string) {
  return string.charAt(0).toUpperCase() + string.slice(1)
}

export function getNested(obj, level, ...rest) {
  if (obj === undefined || obj === null) return undefined
  if (rest.length === 0 && Object.prototype.hasOwnProperty.call(obj, level))
    return obj[level]
  return getNested(obj[level], ...rest)
}

export function getDeferredPromise(then) {
  let res, rej

  const promise = new Promise((resolve, reject) => {
    res = resolve
    rej = reject
  })

  promise.resolve = res
  promise.reject = rej

  if (then) {
    promise.then(() => {
      then()
    })
  }

  return promise
}

export function getJwtFromCookie(req) {
  if (req.headers.cookie) {
    const cookies = cookie.parse(req.headers.cookie)

    if (cookies['__Secure-apollo-token']) {
      const cookie = decode(cookies['__Secure-apollo-token'])

      if (cookie.exp > Date.now() / 1000) {
        return {
          jwt: cookies['__Secure-apollo-token'],
          jwtDecoded: cookie,
        }
      } else {
        consola.debug('Token expired.')
      }
    } else {
      consola.debug('No token cookie.')
    }
  } else {
    consola.debug('No cookie header.')
  }
}

export async function jwtRefresh(apolloClient, store, res, jwtId) {
  consola.trace('Refreshing a JWT...')

  const jwtRefreshData = await apolloClient
    .mutate({
      mutation: JWT_REFRESH_MUTATION,
      variables: {
        jwtId,
      },
    })
    .then(({ data }) => getNested(data, 'jwtRefresh'))
    .catch((error) => {
      consola.error(error)
      signOut(apolloClient, store, res)
    })

  if (!jwtRefreshData) {
    return
  }

  await storeJwt(apolloClient, store, res, jwtRefreshData.jwt)
}

async function signOut(apolloClient, store, res) {
  await storeJwt(apolloClient, store, res, null)
}

export function objectClone(object) {
  const objectClone = JSON.parse(JSON.stringify(object))
  return objectClone
}

export function removeTypename(object) {
  const objectClone = this.objectClone(object)
  delete objectClone.__typename
  return objectClone
}

export async function storeJwt(
  apolloClient,
  store,
  res,
  jwt,
  then = () => {
    window.location.reload()
  }
) {
  consola.debug('Storing the following JWT: ' + jwt)
  store.commit('setJwt', jwt)

  await apolloClient.clearStore()

  if (process.server) {
    res.setHeader(
      'Set-Cookie',
      cookie.serialize('__Secure-apollo-token', jwt, {
        expires: jwt ? new Date(Date.now() + 86400 * 1000 * 31) : new Date(0),
        httpOnly: true,
        path: '/',
        sameSite: 'strict',
        secure: true,
      })
    )
  } else {
    const xhr = new XMLHttpRequest()

    xhr.open('POST', '/auth', true)

    if (jwt) {
      xhr.setRequestHeader('Authorization', 'Bearer ' + jwt)
    }

    xhr.onreadystatechange = () => {
      if (xhr.readyState === 4) {
        switch (xhr.status) {
          case 200:
            then()
            break
          case 500:
            alert('Authorization failed!')
            break
          default:
            alert('Authorization returned an unexpected status code.')
        }
      }
    }
    xhr.send()
  }
}

export default async ({ app, req, res, store }, inject) => {
  const global = {
    ITEMS_PER_PAGE,
    REGEX_SLUG,
    REGEX_UUID,
    VERIFICATION_FORMAT_SLUG,
    VERIFICATION_FORMAT_UUID,
    authenticateAnonymous,
    capitalizeFirstLetter,
    getNested,
    getDeferredPromise,
    getJwtFromCookie,
    jwtRefresh,
    objectClone,
    removeTypename,
    signOut,
    storeJwt,
  }

  inject('global', global)

  // Either authenticate anonymously or refresh token on page load.
  if (process.server) {
    const jwtData = getJwtFromCookie(req)
    if (jwtData) {
      await jwtRefresh(
        app.apolloProvider.defaultClient,
        store,
        res,
        jwtData.jwtDecoded.id
      )
    } else {
      await authenticateAnonymous(app.apolloProvider.defaultClient, store, res)
    }
  }
}
