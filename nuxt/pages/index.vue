<template>
  <Loader
    v-if="($apollo.loading && !allEvents) || graphqlError"
    :error-message="graphqlError ? String(graphqlError) : undefined"
  />
  <div v-else class="flex flex-1 flex-col">
    <section v-if="eventsUpcoming && eventsUpcoming.length > 0">
      <h2>
        {{ $t('titleEventsUpcoming') }}
      </h2>
      <ul>
        <li
          v-for="eventUpcoming in eventsUpcoming"
          :key="eventUpcoming.id"
          class="text-xl"
        >
          <nuxt-link :to="localePath(`/event/${eventUpcoming.name}`)">
            {{ `${$t('title')} ${eventUpcoming.name}` }}
          </nuxt-link>
        </li>
      </ul>
    </section>
    <div class="flex flex-1 flex-col justify-center font-serif">
      <div class="flex flex-col items-baseline md:flex-row">
        <h1 class="mb-0 inline text-6xl leading-normal md:mb-4">
          {{ title }}
        </h1>
        <span class="mb-4 ml-4 text-xl md:mb-0">
          {{ $t('transcription') }}
        </span>
      </div>
      <i18n class="prose text-2xl" path="description" tag="p">
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
    <section v-if="eventsPast && eventsPast.length > 0">
      <h2>
        {{ $t('titleEventsPast') }}
      </h2>
      <ul>
        <li v-for="eventPast in eventsPast" :key="eventPast.id" class="text-xl">
          <nuxt-link :to="localePath(`/event/${eventPast.name}`)">
            {{ `${$t('title')} ${eventPast.name}` }}
          </nuxt-link>
        </li>
      </ul>
    </section>
  </div>
</template>

<script>
import ALL_EVENTS from '~/gql/query/event/allEvents.gql'

export default {
  name: 'IndexPage',
  apollo: {
    allEvents() {
      return {
        query: ALL_EVENTS,
        update: (data) => this.$util.getNested(data, 'allEvents', 'nodes'),
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
    eventsPast() {
      return this.allEvents?.filter((event) =>
        this.$moment(event.start).isBefore(this.$moment())
      )
    },
    eventsUpcoming() {
      return this.allEvents?.filter((event) =>
        this.$moment(event.start).isAfter(this.$moment())
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
  titleEventsPast: Vergangene TrapParties
  titleEventsUpcoming: Zukünftige TrapParties
  transcription: '[træp ˈpɑr-ti]'
</i18n>
