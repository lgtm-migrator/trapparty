<template>
  <div v-if="!isLoaded">
    <LoaderIndicatorSpinner class="h-16 w-16" />
  </div>
  <div v-else-if="games && games.length > 0">
    <h1 class="m-0">{{ $t('games') }}</h1>
    <ol class="list-decimal">
      <StatisticGame v-for="game in games" :key="game.id" :game="game" />
    </ol>
  </div>
  <div v-else>
    {{ $t('gamesNone') }}
  </div>
</template>

<script lang="ts">
import consola from 'consola'

import EVENT_BY_NAME_QUERY from '~/gql/query/event/eventByName.gql'
import GAMES_ALL_QUERY from '~/gql/query/game/allGames.gql'
import {
  GameRandomFactsRound,
  GameRandomFactsVote,
  Event as TrappartyEvent,
  Game,
} from '~/types/trapparty'

import { defineComponent } from '#app'

export default defineComponent({
  name: 'IndexPage',
  data() {
    return {
      games: undefined as Array<any> | undefined,
      gameRandomFactsRound: undefined as GameRandomFactsRound | undefined,
      gameRandomFactsVotes: undefined as GameRandomFactsVote[] | undefined,
      graphqlError: undefined as any,
      isLoaded: false,
      title: this.$t('title'),
    }
  },
  async mounted() {
    const eventResult = await this.$apollo
      .query({
        query: EVENT_BY_NAME_QUERY,
        variables: {
          eventName: '2021',
        },
      })
      .catch((error) => {
        this.graphqlError = error.message
        consola.error(error)
      })

    if (!eventResult) return this.loadingStop()
    const event = this.$util.getNested(
      eventResult,
      'data',
      'eventByName'
    ) as TrappartyEvent

    const gamesResult = await this.$apollo
      .query({
        query: GAMES_ALL_QUERY,
        variables: {
          eventId: +event.id,
          type: 'RANDOM_FACTS',
        },
      })
      .catch((error) => {
        this.graphqlError = error.message
        consola.error(error)
      })

    if (!gamesResult) return this.loadingStop()
    const games = this.$util.getNested(
      gamesResult,
      'data',
      'allGames',
      'nodes'
    ) as Game[]

    this.games = games

    this.loadingStop()
  },
  methods: {
    loadingStop() {
      this.isLoaded = true
    },
  },
})
</script>

<i18n lang="yml">
de:
  games: Spiele
  gamesNone: Keine Spiele vorhanden.
  leaderboardNone: Keine Rangliste vorhanden.
  title: Statistiken
</i18n>
