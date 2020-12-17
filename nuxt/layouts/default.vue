<template>
  <div>
    <div class="container min-h-screen mx-auto p-4 text-center">
      <header class="flex items-center justify-between mb-4 relative">
        <nuxt-link :aria-label="$t('home')" :to="localePath('/')">
          <div id="logo" class="h-16 w-16" />
        </nuxt-link>
        <div class="flex justify-center">
          <a
            :aria-label="$t('githubLinkTitle')"
            class="items-center flex"
            href="https://github.com/dargmuesli/trapparty/"
            rel="noopener noreferrer"
            target="_blank"
          >
            <FontAwesomeIcon
              class="colorInverse mr-2"
              :icon="['fab', 'github']"
              size="lg"
            />
          </a>
        </div>
      </header>
      <nuxt class="text-lg" />
    </div>
    <footer>
      <div class="justify-around container flex mx-auto p-4">
        <!-- <div class="flex flex-col">
          <FontAwesomeIcon
            :icon="['fas', 'language']"
            class="my-2"
            title="language"
          />
          <nuxt-link
            v-for="locale in availableLocales"
            :key="locale.code"
            :to="switchLocalePath(locale.code)"
            >{{ locale.name }}</nuxt-link
          >
        </div> -->
        <div class="flex flex-col">
          <FontAwesomeIcon
            :icon="['fas', 'balance-scale']"
            class="my-2"
            title="scale"
          />
          <nuxt-link :to="localePath('/imprint')">{{
            $t('imprint')
          }}</nuxt-link>
          <nuxt-link :to="localePath('/privacy-policy')">{{
            $t('privacyPolicy')
          }}</nuxt-link>
        </div>
      </div>
    </footer>
  </div>
</template>

<script>
export default {
  head() {
    return this.$nuxtI18nSeo()
  },
  computed: {
    availableLocales() {
      return this.$i18n.locales.filter((i) => i.code !== this.$i18n.locale)
    },
    signedInUsername() {
      return this.$store.state.jwtDecoded &&
        this.$store.state.jwtDecoded.role === 'maevsi_authenticated' &&
        this.$store.state.jwtDecoded.exp > Math.floor(Date.now() / 1000)
        ? this.$store.state.jwtDecoded.username
        : undefined
    },
  },
  beforeCreate() {
    this.$moment.locale(this.$i18n.locale)
  },
}
</script>

<style scoped>
#logo {
  background-image: url(/assets/static/logos/trapparty.svg);
  background-repeat: no-repeat;
  background-size: contain;
}
</style>

<i18n lang="yml">
de:
  authenticated: 'Konto'
  githubLinkTitle: 'TrapParty auf GitHub'
  home: 'Nach Hause'
  imprint: 'Impressum'
  privacyPolicy: 'Datenschutzerklärung'
  session: 'Sitzung'
  settings: 'Einstellungen'
en:
  authenticated: 'Account'
  githubLinkTitle: 'TrapParty on GitHub'
  home: 'Head home'
  imprint: 'Imprint'
  privacyPolicy: 'Privacy Policy'
  session: 'Session'
  settings: 'Settings'
</i18n>
