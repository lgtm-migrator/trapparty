<template>
  <Loader
    :graphql-error-message="graphqlErrorMessage"
    :loading="$apollo.loading"
  >
    <h1 class="text-center">
      {{ title }}
    </h1>
    <div v-if="event">
      <p class="text-center">
        {{ $t('eventName', { name: $global.getNested(event, 'name') }) }}
      </p>
      <Donation class="mb-8" :event="event" />
      <ChartScoring class="mb-8" :event="event" />
    </div>
    <div v-else class="alert">
      {{ $t('datalessEvent') }}
    </div>
  </Loader>
</template>

<script>
import EVENT_BY_NAME from '~/gql/query/event/eventByName'

export default {
  apollo: {
    event() {
      return {
        query: EVENT_BY_NAME,
        variables: {
          eventName: this.$route.params.eventName,
        },
        update: (data) => this.$global.getNested(data, 'eventByName'),
        error(error, _vm, _key, _type, _options) {
          this.graphqlErrorMessage = error.message
        },
      }
    },
  },
  data() {
    return {
      allGames: undefined,
      graphqlErrorMessage: undefined,
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
