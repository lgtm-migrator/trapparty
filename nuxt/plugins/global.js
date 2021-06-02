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

export function objectClone(object) {
  const objectClone = JSON.parse(JSON.stringify(object))
  return objectClone
}

export function removeTypename(object) {
  const objectClone = this.objectClone(object)
  delete objectClone.__typename
  return objectClone
}

export function sortBy(property) {
  return (a, b) => {
    if (a[property] < b[property]) return -1
    if (a[property] > b[property]) return 1
    return 0
  }
}

export default (_ctx, inject) => {
  const global = {
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
    capitalizeFirstLetter,
    getNested,
    getDeferredPromise,
    objectClone,
    removeTypename,
    sortBy,
  }

  inject('global', global)
}
