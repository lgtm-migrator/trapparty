<template>
  <div>
    <div class="container mx-auto flex min-h-screen flex-col p-4">
      <header class="relative mb-4 flex items-center justify-between">
        <AppLink :aria-label="$t('home')" :to="localePath('/')">
          <div id="logo" class="h-16 w-16" />
        </AppLink>
        <AppLink class="text-gray-900 dark:text-white" :to="localePath('/')">
          <FontAwesomeIcon :icon="['fas', 'home']" size="lg" />
        </AppLink>
      </header>
      <div class="flex flex-1 flex-col">
        <nuxt />
      </div>
    </div>
    <footer>
      <div class="container mx-auto flex justify-around p-4">
        <div class="flex flex-col">
          <FontAwesomeIcon
            :icon="['fas', 'balance-scale']"
            class="my-2"
            title="scale"
          />
          <AppLink :to="localePath('/imprint')">
            {{ $t('imprint') }}
          </AppLink>
          <AppLink :to="localePath('/privacy-policy')">
            {{ $t('privacyPolicy') }}
          </AppLink>
        </div>
        <div class="flex flex-col">
          <FontAwesomeIcon :icon="['fas', 'link']" class="my-2" />
          <AppLink
            :title="$t('githubLinkTitle')"
            to="https://github.com/dargmuesli/trapparty/"
          >
            {{ $t('sourceCode') }}
          </AppLink>
        </div>
      </div>
    </footer>
  </div>
</template>

<script>
export default {
  name: 'IndexPage',
  head() {
    return this.$nuxtI18nHead({ addSeoAttributes: true })
  },
  computed: {
    availableLocales() {
      return this.$i18n.locales.filter((i) => i.code !== this.$i18n.locale)
    },
  },
  beforeCreate() {
    this.$moment.locale(this.$i18n.locale)
  },
}
</script>

<style scoped>
#logo {
  background-image: url('/assets/static/logos/trapparty.svg');
  background-repeat: no-repeat;
  background-size: contain;
}
</style>

<i18n lang="yml">
de:
  account: 'Konto'
  githubLinkTitle: 'TrapParty auf GitHub'
  home: 'Nach Hause'
  imprint: 'Impressum'
  privacyPolicy: 'Datenschutzerklärung'
  session: 'Sitzung'
  settings: 'Einstellungen'
  sourceCode: Quellcode
en:
  account: 'Account'
  githubLinkTitle: 'TrapParty on GitHub'
  home: 'Head home'
  imprint: 'Imprint'
  privacyPolicy: 'Privacy Policy'
  session: 'Session'
  settings: 'Settings'
  sourceCode: Quellcode
</i18n>
