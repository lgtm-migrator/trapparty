<template>
  <Loader
    :graphql-error-message="graphqlErrorMessage"
    :loading="$apollo.loading"
  >
    <h1>
      {{ title }}
    </h1>
    <div v-if="allEventsNewest">
      <p>
        {{
          $t('eventName', { name: $global.getNested(allEventsNewest, 'name') })
        }}
      </p>
      <Donation class="mb-8" :event="allEventsNewest" />
      <ChartScoring class="mb-8" :event="allEventsNewest" />
    </div>
    <div v-else class="alert">
      {{ $t('datalessEvent') }}
    </div>
  </Loader>
</template>

<script>
import ALL_EVENTS_NEWEST from '~/gql/query/allEventsNewest'

export default {
  apollo: {
    allEventsNewest() {
      return {
        query: ALL_EVENTS_NEWEST,
        update: (data) => this.$global.getNested(data, 'allEvents', 'nodes')[0],
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
