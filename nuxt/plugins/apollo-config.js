export default (_ctx) => {
  return {
    httpEndpoint: process.server
      ? 'http://trapparty_postgraphile:5000/graphql'
      : 'https://trapparty_postgraphile.' +
        (process.env.NUXT_ENV_STACK_DOMAIN || 'jonas-thelemann.test') +
        '/graphql',
  }
}
