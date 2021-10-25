<template>
  <Loader
    v-if="($apollo.loading && !allEvents) || graphqlError"
    :error-message="graphqlError ? String(graphqlError) : undefined"
  />
  <div v-else class="flex flex-1 flex-col">
    <div class="flex flex-1 flex-col font-serif justify-center">
      <div class="flex flex-col md:flex-row items-baseline">
        <h1 class="inline leading-normal mb-0 md:mb-4 text-6xl">
          {{ title }}
        </h1>
        <span class="mb-4 md:mb-0 ml-4 text-xl">
          {{ $t('transcription') }}
        </span>
      </div>
      <i18n class="text-2xl prose" path="description" tag="p">
        <template #author>
          <AppLink
            to="https://jonas-thelemann.de"
            :title="$t('authorLinkTitle')"
          >
            Jonas Thelemann
          </AppLink>
        </template>
      </i18n>
    </div>
    <h2>
      {{ $t('titlePastEvents') }}
    </h2>
    <ul>
      <li v-for="pastEvent in pastEvents" :key="pastEvent.id" class="text-xl">
        <nuxt-link :to="localePath(`/event/${pastEvent.name}`)">
          {{ `${$t('title')} ${pastEvent.name}` }}
        </nuxt-link>
      </li>
    </ul>
  </div>
</template>

<script>
import ALL_EVENTS from '~/gql/query/event/allEvents'

export default {
  apollo: {
    allEvents() {
      return {
        query: ALL_EVENTS,
        update: (data) => this.$global.getNested(data, 'allEvents', 'nodes'),
        error(error, _vm, _key, _type, _options) {
          this.graphqlError = error.message
        },
      }
    },
  },
  data() {
    return {
      graphqlError: undefined,
      title: this.$t('title'),
    }
  },
  head() {
    return {
      title: this.title,
    }
  },
  computed: {
    pastEvents() {
      return this.allEvents?.filter((event) =>
        this.$moment(event.start).isBefore(this.$moment())
      )
    },
  },
}
</script>

<i18n lang="yml">
de:
  authorLinkTitle: 'Jonas Website'
  description: 'Die TrapParty ist eine große Feier, die seit 2017 jährlich von {author} zum Anlass seines Geburtstags veranstaltet wird. Sie hat das Ziel, den Gästen Freude zu bereiten und ein wohliges Gemeinschaftsgefühl zu schaffen. Auf dieser Seite findest du alle Informationen über diese Feier, die von einigen auch "beste Party des Jahres" genannt wird. Naja, Jonas veranstaltet die Feier ja auch immer kurz vor Weihnachten, wie soll denn da auch noch eine andere Feier diesen Titel strittig machen.'
  title: TrapParty
  titlePastEvents: Vergangene TrapParties
  transcription: '[træp ˈpɑr-ti]'
</i18n>
