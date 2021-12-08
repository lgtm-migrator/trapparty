import { Context } from '@nuxt/types'
import createPersistedState from 'vuex-persistedstate'
import Cookies from 'js-cookie'
import { parse } from 'cookie'

import { getNested } from './util'

export default ({ store, req }: Context) => {
  if (!getNested(req, 'headers', 'cookie')) return

  createPersistedState({
    paths: ['participationData'],
    storage: {
      getItem: (key) => {
        // See https://nuxtjs.org/guide/plugins/#using-process-flags
        if (process.server) {
          if (!req.headers.cookie) return
          const parsedCookies = parse(req.headers.cookie)
          return parsedCookies[key]
        } else {
          return Cookies.get(key)
        }
      },
      // Please see https://github.com/js-cookie/js-cookie#json, on how to handle JSON.
      setItem: (key, value) =>
        Cookies.set(key, value, { expires: 365, secure: true }),
      removeItem: (key) => Cookies.remove(key),
    },
  })(store)
}
