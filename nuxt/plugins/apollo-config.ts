import { Context } from '@nuxt/types'

export default (_ctx: Context) => {
  return {
    httpEndpoint: process.server
      ? 'http://trapparty-postgraphile:5000/graphql'
      : 'https://trapparty-postgraphile.' +
        (process.env.NUXT_ENV_STACK_DOMAIN || 'jonas-thelemann.test') +
        '/graphql',
  }
}
