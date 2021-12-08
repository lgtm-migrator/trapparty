<template>
  <Loader
    v-if="($apollo.loading && !event) || graphqlError"
    :error-message="graphqlError ? String(graphqlError) : undefined"
  />
  <div v-else>
    <h1 class="text-center">
      {{ title }}
    </h1>
    <div v-if="event">
      <p class="text-center">
        {{ $t('eventName', { name: $util.getNested(event, 'name') }) }}
      </p>
      <Donation class="mb-8" :event="event" />
      <ChartScoring class="mb-8" :event="event" />
    </div>
    <div v-else class="alert">
      {{ $t('datalessEvent') }}
    </div>
  </div>
</template>

<script>
import EVENT_BY_NAME from '~/gql/query/event/eventByName.gql'

export default {
  name: 'IndexPage',
  apollo: {
    event() {
      return {
        query: EVENT_BY_NAME,
        variables: {
          eventName: this.$route.params.eventName,
        },
        update: (data) => this.$util.getNested(data, 'eventByName'),
        error(error, _vm, _key, _type, _options) {
          this.graphqlError = error.message
        },
      }
    },
  },
  data() {
    return {
      allGames: undefined,
      graphqlError: undefined,
      title: this.$t('title'),
    }
  },
  head() {
    return {
      title: this.title,
    }
  },
}
</script>

<i18n lang="yml">
de:
  datalessEvent: 'Kein Event gefunden!'
  eventName: 'Für die Trapparty {name}.'
  title: 'Statistiken'
  titleScore: 'Teamwertung'
</i18n>
