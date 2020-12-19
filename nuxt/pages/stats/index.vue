<template>
  <Loader
    :graphql-error-message="graphqlErrorMessage"
    :loading="$apollo.loading"
  >
    <h1>
      {{ title }}
    </h1>
    <p>{{ JSON.stringify(allGames) }}</p>
    <ChartScore :event="allEventsNewest" />
    <ChartDonationAmount :event="allEventsNewest" />
    <ChartScoreTotal :event="allEventsNewest" />
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
  title: 'Stats'
</i18n>
