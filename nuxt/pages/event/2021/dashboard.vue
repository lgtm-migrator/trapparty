<template>
  <Loader
    v-if="($apollo.loading && !event) || graphqlError"
    :error-message="graphqlError ? String(graphqlError) : undefined"
  />
  <div v-else-if="games && games.length > 0">
    <h1>
      {{ title }}
    </h1>
    <h2>
      {{ $t('games') }}
    </h2>
    <ul class="flex flex-col gap-4">
      <li
        v-for="game in games"
        :key="game.id"
        class="border border-gray-900 dark:border-white px-8 md:px-16 py-4 md:py-8 rounded"
      >
        <GameTitle :game="game" />
        <div class="flex gap-4">
          <Button
            v-if="
              game.isActive &&
              $util.getNested($store.state.participationData, 'role') ===
                'player'
            "
            :aria-label="$t('gameLink')"
            :to="localePath(`/game/${game.id}`)"
          >
            {{ $t('gameLink') }}
          </Button>
          <Button
            :aria-label="$t('gameLinkStatistic')"
            :to="localePath(`/game/${game.id}/statistic`)"
          >
            {{ $t('gameLinkStatistic') }}
          </Button>
        </div>
      </li>
    </ul>
  </div>
  <div v-else>{{ $t('gamesNone') }}</div>
</template>

<script lang="ts">
import consola from 'consola'

import { defineComponent } from '#app'
import EVENT_BY_NAME_QUERY from '~/gql/query/event/eventByName.gql'
import GAMES_ALL_QUERY from '~/gql/query/game/allGames.gql'
import { Game } from '~/types/trapparty'

export default defineComponent({
  name: 'IndexPage',
  apollo: {
    event() {
      return {
        query: EVENT_BY_NAME_QUERY,
        variables: {
          eventName: '2021',
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
      games: undefined as Game[] | undefined,
      graphqlError: undefined,
      title: this.$t('title'),
    }
  },
  head() {
    return {
      title: this.title,
    }
  },
  watch: {
    event(eventNew) {
      if (!eventNew) return

      this.$apollo
        .query({
          query: GAMES_ALL_QUERY,
          variables: {
            eventId: eventNew.id,
          },
        })
        .then((data) => {
          this.games = this.$util.getNested(data, 'data', 'allGames', 'nodes')
        })
        .catch((error) => {
          this.graphqlError = error.message
          consola.error(error)
        })
    },
  },
})
</script>

<i18n lang="yml">
de:
  games: Spiele
  gamesNone: Keine Spiele vorhanden.
  gameLink: Zum Spiel
  gameLinkStatistic: Zur Statistik
  title: 'TrapParty 2021'
</i18n>
