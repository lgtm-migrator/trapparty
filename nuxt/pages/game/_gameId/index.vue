<template>
  <div
    v-if="$util.getNested($store.state.participationData, 'role') !== 'player'"
  >
    {{ $t('playerNone') }}
  </div>
  <div v-else-if="!game">
    {{ $t('gameNone') }}
  </div>
  <div v-else-if="!game.isActive">
    {{ $t('gameActiveNone') }}
  </div>
  <div v-else>
    <!-- <span class="text-gray-500">
      {{ $t('gameType', { type: gameTypeReadable }) }}
    </span> -->
    <div class="flex items-center justify-between">
      <GameTitle :game="game" />
      <Button
        :aria-label="$t('gameLinkStatistic')"
        :to="localePath(`/game/${game.id}/statistic`)"
      >
        {{ $t('gameLinkStatistic') }}
      </Button>
    </div>
    <GameRandomFacts v-if="game.type === 'RANDOM_FACTS'" :game-id="game.id" />
    <div v-else>
      {{ $t('gameTypeUnexpected') }}
    </div>
  </div>
</template>

<script lang="ts">
import consola from 'consola'

import GAME_BY_ID_QUERY from '~/gql/query/game/gameById.gql'
import { Game, GameType } from '~/types/trapparty'

import { defineComponent } from '#app'

export default defineComponent({
  name: 'IndexPage',
  apollo: {
    game() {
      return {
        query: GAME_BY_ID_QUERY,
        variables: {
          gameId: +this.$route.params.gameId,
        },
        update: (data) => this.$util.getNested(data, 'gameById'),
        error(error: any) {
          this.graphqlError = error.message
          consola.error(error.message)
        },
      }
    },
  },
  data() {
    return {
      graphqlError: undefined,
      // questionerName: 'Jonas Thelemann',
      round: undefined,
      score: 0,
      title: this.$t('title'),
    }
  },
  head() {
    return {
      title: this.title,
    }
  },
  computed: {
    gameTypeReadable() {
      if (!this.game) return

      switch ((this.game as Game).type) {
        case GameType.RANDOM_FACTS:
          return this.$t('gameTypeRandomFacts')
        case GameType.TEAM_SCORE:
          return this.$t('gameTypeTeamScore')
        default:
          consola.error(this.$t('gameTypeUnexpected'))
          return undefined
      }
    },
    name() {
      if (!this.participationData) return
      return this.participationData.name
    },
  },
})
</script>

<i18n lang="yml">
de:
  gameActiveNone: Spiel ist nicht aktiv.
  gameLinkStatistic: Zur Statistik
  gameNone: Kein Spiel vorhanden.
  gameType: 'Spielmodus: {type}'
  gameTypeRandomFacts: 'random facts'
  gameTypeTeamScore: 'team score'
  gameTypeUnexpected: Spieltyp konnte nicht angezeigt werden.
  playerNone: Du siehst nicht aus wie ein Spieler 🤔
  title: Spiel
</i18n>
