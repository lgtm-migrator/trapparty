import { defineNuxtConfig } from '@nuxt/bridge'
import shrinkRay from 'shrink-ray-current'

import { BASE_URL, STACK_DOMAIN } from './plugins/baseUrl'

export default defineNuxtConfig({
  alias: {
    tslib: 'tslib/tslib.es6.js',
  },
  // Build Configuration (https://go.nuxtjs.dev/config-build)
  build: {
    babel: {
      presets() {
        return [
          ['@nuxt/babel-preset-app', { loose: true, corejs: { version: 3 } }],
        ]
      },
      plugins: ['@babel/plugin-proposal-numeric-separator'],
    },
    /*
     ** You can extend webpack config here
     */
    extractCSS: true,
    transpile: [
      '@http-util/status-i18n',
      'color',
      'cross-fetch',
      'graphql',
      'hash.js',
      'iterall',
      'lodash',
      'moment',
      'node-fetch',
      'subscriptions-transport-ws',
      'tslib',
      'universal-cookie',
    ],
  },

  // Modules for dev and build (recommended) (https://go.nuxtjs.dev/config-modules)
  buildModules: [
    [
      '@nuxtjs/fontawesome',
      {
        icons: {
          brands: ['faYoutube'],
          solid: [
            'faBalanceScale',
            'faBug',
            'faChartBar',
            'faDownload',
            'faExclamationCircle',
            'faHeart',
            'faHome',
            'faLink',
            'faShareAlt',
            'faSignInAlt',
            'faTv',
          ],
        },
        useLayers: false,
        useLayersText: false,
      },
    ],
    '@nuxtjs/html-validator',
    // Doc: https://github.com/nuxt-community/moment-module
    ['@nuxtjs/moment', { locales: ['de'] }],
    // https://go.nuxtjs.dev/stylelint
    '@nuxtjs/stylelint-module',
    // https://go.nuxtjs.dev/tailwindcss
    [
      '@nuxtjs/tailwindcss',
      {
        viewer: false,
      },
    ],
  ],

  // Auto import components (https://go.nuxtjs.dev/config-components)
  components: true,

  // Global page headers (https://go.nuxtjs.dev/config-head)
  head() {
    return {
      bodyAttrs: { class: 'font-sans h-full dark-mode:text-white' },
      htmlAttrs: { class: 'h-full' },
      link: [
        {
          href: '/assets/static/favicon/apple-touch-icon.png',
          rel: 'apple-touch-icon',
          sizes: '180x180',
        },
        {
          href: '/assets/static/favicon/favicon-16x16.png',
          rel: 'icon',
          sizes: '16x16',
          type: 'image/png',
        },
        {
          href: '/assets/static/favicon/favicon-32x32.png',
          rel: 'icon',
          sizes: '32x32',
          type: 'image/png',
        },
        {
          href: '/assets/static/favicon/favicon.ico',
          rel: 'icon',
          type: 'image/x-icon',
        },
        {
          href: '/assets/static/favicon/site.webmanifest',
          rel: 'manifest',
        },
        {
          color: '#202020',
          href: '/assets/static/favicon/safari-pinned-tab.svg',
          rel: 'mask-icon',
        },
        {
          href: '/assets/static/favicon/favicon.ico',
          rel: 'shortcut icon',
        },
      ],
      meta: [
        { charset: 'utf-8' },
        { content: 'width=device-width, initial-scale=1', name: 'viewport' },
        {
          hid: 'description',
          name: 'description',
          property: 'description',
          content: this.$t('globalOgSeoDescription'),
        },
        {
          hid: 'og:description',
          property: 'og:description',
          content: this.$t('globalOgSeoDescription'),
        },
        {
          content: '/assets/static/favicon/browserconfig.xml',
          name: 'msapplication-config',
        },
        {
          content: '#161616',
          name: 'msapplication-TileColor',
        },
        {
          content: '#161616',
          name: 'theme-color',
        },
        {
          hid: 'og:image',
          property: 'og:image',
          content: this.$baseUrl + '/assets/static/logos/trapparty.svg',
        },
        {
          hid: 'og:image:alt',
          property: 'og:image:alt',
          content: this.$t('globalOgImageAlt'),
        },
        {
          hid: 'og:type',
          property: 'og:type',
          content: 'website', // https://ogp.me/#types
        },
      ],
      titleTemplate: (titleChunk: any) => {
        return titleChunk ? `${titleChunk} · TrapParty` : 'TrapParty'
      },
    }
  },

  /*
   ** Customize the progress-bar color
   */
  loading: { color: '#fff' },

  // Modules (https://go.nuxtjs.dev/config-modules)
  modules: [
    [
      'nuxt-helmet',
      {
        hsts: {
          maxAge: 31536000,
          preload: true,
        },
      },
    ], // Should be declared at the start of the array.
    [
      '@nuxtjs/i18n',
      {
        baseUrl: BASE_URL,
        defaultLocale: 'de', // Must be set for the default prefix_except_default prefix strategy.
        detectBrowserLanguage: {
          cookieSecure: true,
          redirectOn: 'root',
        },
        locales: [
          // {
          //   code: 'en',
          //   name: 'English',
          //   iso: 'en', // Will be used as catchall locale by default.
          // },
          {
            code: 'de',
            name: 'Deutsch',
            iso: 'de',
          },
        ],
        vueI18n: {
          messages: {
            de: {
              globalLoading: 'Lade...',
              globalOgImageAlt: 'TrapPartys Logo.',
              globalOgSeoDescription: 'TrapPartys Online-Version.',
              globalValidationFailed: 'Bitte überprüfe deine Eingaben 🙈',
              globalValidationFormatIncorrect: 'Falsches Format.',
              globalValidationRequired: 'Pflichtfeld.',
            },
            en: {
              globalLoading: 'Loading...',
              globalOgImageAlt: "TrapParty's logo.",
              globalOgSeoDescription: "TrapParty's online version.",
              globalValidationFailed: 'Please check your input 🙈',
              globalValidationFormatIncorrect: 'Incorrect format.',
              globalValidationRequired: 'Required.',
            },
          },
          silentFallbackWarn: true,
        },
        vueI18nLoader: true,
      },
    ],
    [
      '@nuxtjs/apollo',
      {
        clientConfigs: {
          default: '~/plugins/apollo-config.ts',
        },
        defaultOptions: {
          $query: {
            fetchPolicy: 'cache-and-network',
          },
        },
      },
    ],
    [
      '@nuxtjs/robots',
      {
        Allow: ['/'],
        Disallow: ['/robots.txt'], // https://webmasters.stackexchange.com/a/117537/70856
        Sitemap: BASE_URL + '/sitemap.xml',
      },
    ],
    'vue-sweetalert2/nuxt',
    '@nuxtjs/sitemap', // Should be declared at the end of the array.
  ],

  // Plugins to run before rendering page (https://go.nuxtjs.dev/config-plugins)
  plugins: [
    '~/plugins/baseUrl.ts',
    '~/plugins/i18n.ts',
    '~/plugins/persistedState.ts',
    '~/plugins/util.ts',
    '~/plugins/vuelidate.ts',
  ],

  render: {
    compressor: shrinkRay(),
    csp: {
      policies: {
        'base-uri': ["'none'"], // Mozilla Observatory.
        'connect-src': [`https://*.${STACK_DOMAIN}`],
        'default-src': ["'none'"],
        'font-src': ["'self'"],
        'form-action': ["'self'"], // Mozilla Observatory.
        'frame-ancestors': ["'none'"], // Mozilla Observatory.
        'img-src': ['data:', `https://*.${STACK_DOMAIN}`, "'self'"],
        'manifest-src': ["'self'"], // Chrome
        'report-uri': 'https://dargmuesli.report-uri.com/r/d/csp/enforce',
        'script-src': [
          "'self'",
          'https://static.cloudflareinsights.com/beacon.min.js',
        ],
        'style-src': ["'self'", "'unsafe-inline'"], // Tailwind, ChartJS (TODO: https://www.chartjs.org/docs/latest/getting-started/integration.html#content-security-policy)
      },
      reportOnly: false,
    },
  },
})
