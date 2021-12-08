import { Context } from '@nuxt/types'
import { Inject } from '@nuxt/types/app'
import { helpers } from 'vuelidate/lib/validators'

export const CHART_DIRECTION_BREAKPOINT = 768
export const EVENT_DESCRIPTION_MAXIMUM = 10000
export const EVENT_NAME_MAXIMUM = 100
export const EVENT_PLACE_MAXIMUM = 300
export const EVENT_SLUG_MAXIMUM = 100
export const ITEMS_PER_PAGE = 8
export const PASSWORD_LENGTH_MINIMUM = 8
export const REGEX_SLUG = /^[-A-Za-z0-9]+$/
export const REGEX_UUID =
  /^[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}$/
export const VERIFICATION_FORMAT_SLUG = helpers.regex('slug', REGEX_SLUG)
export const VERIFICATION_FORMAT_UUID = helpers.regex('uuid', REGEX_UUID)

export function formPreSubmit(that: any): Promise<void> {
  return new Promise<void>((resolve, reject) => {
    that.graphqlError = undefined
    that.$v.$touch()

    // Workaround until https://vuelidate-next.netlify.app/.
    const waitPending = () => {
      if (that.$v.$pending) {
        setTimeout(() => {
          waitPending()
        }, 100)
      } else {
        if (that.$v.$invalid) {
          reject(Error('Form is invalid!'))
          return
        }

        that.form.sent = true

        resolve()
      }
    }

    waitPending()
  })
}

export function getNested(
  obj: any | undefined | null,
  level: keyof any,
  ...rest: (keyof any)[]
): undefined | any {
  if (obj === undefined || obj === null) return undefined
  if (rest.length === 0 && Object.prototype.hasOwnProperty.call(obj, level))
    return obj[level]
  // @ts-ignore
  return getNested(obj[level], ...rest)
}

export function getDeferredPromise<T>(then?: (value: any) => T): Promise<T> {
  let res, rej

  const promise: any = new Promise((resolve, reject) => {
    res = resolve
    rej = reject
  })

  promise.resolve = res
  promise.reject = rej

  if (then) {
    promise.then((value: any) => {
      then(value)
    })
  }

  return promise
}

export function objectClone<T>(object: T): T {
  return JSON.parse(JSON.stringify(object))
}

export function removeTypename<T extends Object & { __typename?: string }>(
  object: T
): Omit<T, '__typename'> {
  const clonedObject = objectClone<T>(object)
  delete clonedObject.__typename
  return clonedObject
}

const util = {
  CHART_DIRECTION_BREAKPOINT,
  EVENT_DESCRIPTION_MAXIMUM,
  EVENT_NAME_MAXIMUM,
  EVENT_PLACE_MAXIMUM,
  EVENT_SLUG_MAXIMUM,
  ITEMS_PER_PAGE,
  PASSWORD_LENGTH_MINIMUM,
  REGEX_SLUG,
  REGEX_UUID,
  VERIFICATION_FORMAT_SLUG,
  VERIFICATION_FORMAT_UUID,
  formPreSubmit,
  getNested,
  getDeferredPromise,
  objectClone,
  removeTypename,
}

export default (_ctx: Context, inject: Inject) => {
  inject('util', util)
}

declare module 'vue/types/vue' {
  interface Vue {
    $util: typeof util
  }
}

declare module '@nuxt/types' {
  interface NuxtAppOptions {
    $util: typeof util
  }
  interface Context {
    $util: typeof util
  }
}
