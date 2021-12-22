module.exports = {
  content: [
    './components/**/*.{js,vue,ts}',
    './layouts/**/*.vue',
    './pages/**/*.vue',
    './plugins/**/*.{js,ts}',
    './nuxt.config.js',
    './nuxt.config.ts',
  ],
  plugins: [
    function ({ addBase, addComponents, addUtilities, theme }) {
      addBase({
        // '@font-face': {
        //   fontDisplay: 'swap',
        //   fontFamily: 'Montserrat',
        //   src:
        //     "local('Montserrat Medium'), local('Montserrat-Medium'), url(/assets/static/fonts/montserrat/montserrat-medium.woff2) format('woff2')",
        //   unicodeRange:
        //     'U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD',
        // },
        ':disabled': {
          cursor: theme('cursor.not-allowed'),
          opacity: theme('opacity.50'),
        },
        a: {
          color: theme('colors.blue.700'),
          display: 'inline-block',
          '&[target="_blank"]': {
            '&:after': {
              backgroundColor: theme('colors.gray.900'),
              content: '""',
              display: 'inline-block',
              mask: 'url(data:image/svg+xml;base64,PHN2ZyBhcmlhLWhpZGRlbj0idHJ1ZSIgZm9jdXNhYmxlPSJmYWxzZSIgZGF0YS1wcmVmaXg9ImZhcyIgZGF0YS1pY29uPSJleHRlcm5hbC1saW5rLWFsdCIgY2xhc3M9InN2Zy1pbmxpbmUtLWZhIGZhLWV4dGVybmFsLWxpbmstYWx0IGZhLXctMTYiIHJvbGU9ImltZyIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB2aWV3Qm94PSIwIDAgNTEyIDUxMiI+PHBhdGggZmlsbD0iY3VycmVudENvbG9yIiBkPSJNNDMyLDMyMEg0MDBhMTYsMTYsMCwwLDAtMTYsMTZWNDQ4SDY0VjEyOEgyMDhhMTYsMTYsMCwwLDAsMTYtMTZWODBhMTYsMTYsMCwwLDAtMTYtMTZINDhBNDgsNDgsMCwwLDAsMCwxMTJWNDY0YTQ4LDQ4LDAsMCwwLDQ4LDQ4SDQwMGE0OCw0OCwwLDAsMCw0OC00OFYzMzZBMTYsMTYsMCwwLDAsNDMyLDMyMFpNNDg4LDBoLTEyOGMtMjEuMzcsMC0zMi4wNSwyNS45MS0xNyw0MWwzNS43MywzNS43M0wxMzUsMzIwLjM3YTI0LDI0LDAsMCwwLDAsMzRMMTU3LjY3LDM3N2EyNCwyNCwwLDAsMCwzNCwwTDQzNS4yOCwxMzMuMzIsNDcxLDE2OWMxNSwxNSw0MSw0LjUsNDEtMTdWMjRBMjQsMjQsMCwwLDAsNDg4LDBaIj48L3BhdGg+PC9zdmc+) no-repeat 50% 50%',
              maskSize: 'cover',
              height: theme('fontSize.xs'),
              width: theme('fontSize.xs'),
              '@screen dark-mode': {
                backgroundColor: 'currentColor',
              },
            },
            '&.button': {
              '&:after': {
                backgroundColor: theme('colors.white'),
                '@screen dark-mode': {
                  backgroundColor: theme('colors.gray.900'),
                },
              },
              '.card &': {
                '&:after': {
                  backgroundColor: theme('colors.gray.900'),
                  '@screen dark-mode': {
                    backgroundColor: theme('colors.white'),
                  },
                },
              },
            },
          },
          '@screen dark-mode': {
            color: theme('colors.blue.400'),
          },
        },
        address: {
          margin: theme('margin.4'),
        },
        body: {
          background: '#f0f0f0',
          '@screen dark-mode': {
            background: '#161616',
          },
        },
        footer: {
          background: '#ffffff',
          '@screen dark-mode': {
            background: '#1e1e1e',
          },
        },
        h1: {
          fontSize: theme('fontSize.4xl[0]'),
          lineHeight: '3rem',
          marginBottom: theme('margin.4'),
          // fontFamily: 'Montserrat',
          fontWeight: theme('fontWeight.bold'),
          overflow: 'hidden',
          textOverflow: 'ellipsis',
          whiteSpace: 'nowrap',
        },
        h2: {
          fontSize: theme('fontSize.3xl'),
          lineHeight: theme('fontSize.3xl[1].lineHeight'),
          // fontFamily: 'Montserrat',
          fontWeight: theme('fontWeight.bold'),
          marginBottom: theme('margin.1'),
          marginTop: theme('margin.4'),
        },
        h3: {
          fontSize: theme('fontSize.2xl'),
          lineHeight: theme('fontSize.2xl[1].lineHeight'),
          // fontFamily: 'Montserrat',
          fontWeight: theme('fontWeight.bold'),
          marginBottom: theme('margin.1'),
          marginTop: theme('margin.4'),
        },
        h4: {
          fontSize: theme('fontSize.xl'),
          lineHeight: theme('fontSize.xl[1].lineHeight'),
          // fontFamily: 'Montserrat',
          fontWeight: theme('fontWeight.bold'),
          marginBottom: theme('margin.1'),
          marginTop: theme('margin.4'),
        },
        img: {
          '&::before': {
            alignItems: 'center',
            display: 'flex',
            height: '100%',
            justifyContent: 'center',
          },
        },
        ol: {
          listStylePosition: 'inside',
          listStyleType: 'decimal',
        },
        p: {
          margin: theme('margin.4'),
        },
      })
      addComponents({
        '.alert': {
          backgroundColor: theme('colors.red.700'),
          borderRadius: theme('borderRadius.default'),
          color: theme('colors.white'),
          padding: theme('padding.3'),
          textAlign: 'center',
        },
        '.button': {
          backgroundColor: theme('colors.gray.900'),
          borderRadius: theme('borderRadius.full'),
          boxShadow: theme('boxShadow.default'),
          color: theme('colors.gray.100'),
          fontWeight: theme('fontWeight.bold'),
          padding: theme('padding.2') + ' ' + theme('padding.4'),
          '@screen dark-mode': {
            backgroundColor: theme('colors.white'),
            color: theme('colors.gray.900'),
          },
          '&:focus': {
            boxShadow: theme('boxShadow.outline'),
          },
          '&:hover': {
            backgroundColor: theme('colors.gray.800'),
            '@screen dark-mode': {
              backgroundColor: theme('colors.gray.400'),
            },
          },
        },
        '.card': {
          backgroundColor: 'white',
          borderRadius: theme('borderRadius.default'),
          boxShadow: theme('boxShadow.md'),
          color: theme('colors.black'),
          padding: theme('padding.4'),
          form: {
            label: {
              color: theme('colors.gray.600'),
            },
          },
          '.button': {
            backgroundColor: theme('colors.gray.900'),
            color: theme('colors.gray.100'),
            '&:hover': {
              backgroundColor: theme('colors.gray.800'),
            },
          },
        },
        '.colorInverse': {
          color: 'initial',
          '@screen dark-mode': {
            color: 'white',
          },
        },
        '.dropdown-content': {
          display: 'none',
          '>*': {
            display: 'block',
          },
        },
        '.dropdown': {
          '&:hover': {
            '.dropdown-content': {
              display: 'block',
            },
          },
        },
        '.flip-card': {
          perspective: '1000px',
        },
        '.flip-card-inner': {
          transition: 'transform 0.7s',
          transformStyle: 'preserve-3d',
        },
        '.flip-card.flipped .flip-card-inner': {
          transform: 'rotateY(180deg)',
        },
        '.flip-card-front, .flip-card-back': {
          backfaceVisibility: 'hidden',
        },
        '.flip-card-front': {
          transform: 'rotateY(-180deg)',
        },
        '.flip-card-back': {
          transform: 'rotateY(0deg)',
        },
        '.form-input-error': {
          input: {
            borderColor: theme('colors.red.500'),
            '&:focus': {
              borderColor: theme('colors.red.500'),
            },
          },
          label: {
            color: theme('colors.red.500'),
          },
        },
        '.form-input': {
          appearance: 'none',
          backgroundColor: theme('colors.gray.200'),
          borderColor: theme('colors.gray.200'),
          borderRadius: theme('borderRadius.default'),
          borderWidth: theme('borderWidth.2'),
          color: theme('colors.gray.700'),
          lineHeight: theme('lineHeight.tight'),
          padding: theme('padding.2') + ' ' + theme('padding.4'),
          width: theme('width.full'),
          '&:focus': {
            backgroundColor: theme('colors.white'),
            borderColor: theme('colors.purple.500'),
          },
        },
        '.info': {
          backgroundColor: theme('colors.blue.700'),
          borderRadius: theme('borderRadius.default'),
          color: theme('colors.white'),
          padding: theme('padding.3'),
          textAlign: 'center',
        },
        '.pills': {
          display: 'flex',
          justifyContent: 'space-between',
          li: {
            width: theme('width.full'),
            button: {
              fontWeight: theme('fontWeight.semibold'),
              padding: theme('padding.2') + ' ' + theme('padding.4'),
              width: theme('width.full'),
            },
          },
        },
        '.prose': {
          ol: {
            listStylePosition: 'inside',
            listStyleType: 'decimal',
          },
          textAlign: 'left',
          ul: {
            listStylePosition: 'inside',
            listStyleType: 'disc',
          },
        },
        '.unready': {
          backgroundColor: theme('colors.orange.700'),
          borderRadius: theme('borderRadius.default'),
          color: theme('colors.white'),
          padding: theme('padding.3'),
          textAlign: 'center',
        },
      })
      addUtilities({
        '.bg-half-transparent': {
          backgroundColor: 'rgba(0, 0, 0, 0.5)',
        },
        '.e1': {
          gridRow: '1',
          gridColumn: '1',
        },
        '.inline-grid': {
          display: 'inline-grid',
        },
        '.line-clamp-box': {
          display: '-webkit-box',
          overflow: 'hidden',
          textOverflow: 'ellipsis',
          '-webkit-box-orient': 'vertical',
        },
        '.line-clamp-2': {
          '-webkit-line-clamp': '2',
        },
      })
    },
  ],
  theme: {
    extend: {
      animation: {
        shake: 'shake 0.6s ease-in-out 0s 1 normal forwards running',
      },
      keyframes: {
        shake: {
          '0%': {
            transform: 'translateX(0)',
          },
          '15%': {
            transform: 'translateX(0.375rem)',
          },
          '30%': {
            transform: 'translateX(-0.375rem)',
          },
          '45%': {
            transform: 'translateX(0.375rem)',
          },
          '60%': {
            transform: 'translateX(-0.375rem)',
          },
          '75%': {
            transform: 'translateX(0.375rem)',
          },
          '90%': {
            transform: 'translateX(-0.375rem)',
          },
          '100%': {
            transform: 'translateX(0)',
          },
        },
      },
      screens: {
        'dark-mode': { raw: '(prefers-color-scheme: dark)' },
      },
    },
  },
}
