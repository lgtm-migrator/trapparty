import { Context } from '@nuxt/types-edge'
import createPersistedState from 'vuex-persistedstate'
import Cookies from 'js-cookie'
import { useCookie } from 'h3'

export default ({ store, req }: Context) => {
  createPersistedState({
    paths: ['participationData'],
    storage: {
      getItem: (key) => {
        if (process.server) {
          return useCookie(req, key)
        } else {
          return Cookies.get(key)
        }
      },
      setItem: (key, value) =>
        Cookies.set(key, value, { expires: 365, secure: true }),
      removeItem: (key) => Cookies.remove(key),
    },
  })(store)
}
