<template>
  <div v-if="gameId">
    <ul
      v-if="leaderboard && leaderboard.length > 0"
      class="flex flex-wrap gap-2"
    >
      <StatisticGameRandomFactEntry
        v-for="(array, index) in leaderboard"
        :key="index"
        :highscores="highscores"
        :player-id="+array[0]"
        :value="array[1]"
      />
    </ul>
    <div v-else>
      {{ $t('statisticNone') }}
    </div>
  </div>
</template>

<script lang="ts">
import consola from 'consola'

import { defineComponent } from '#app'
import GAME_RANDOM_FACTS_ROUNDS_ALL_QUERY from '~/gql/query/game/allGameRandomFactsRounds.gql'
import GAME_RANDOM_FACTS_VOTES_ALL_QUERY from '~/gql/query/game/allGameRandomFactsVotes.gql'

import { GameRandomFactsRound, GameRandomFactsVote } from '~/types/trapparty'

export default defineComponent({
  props: {
    gameId: {
      required: true,
      type: Number,
    },
  },
  data() {
    return {
      highscores: [] as number[],
      leaderboard: {} as Array<[string, number]>,
      rounds: undefined as GameRandomFactsRound[] | undefined,
      votes: undefined as GameRandomFactsVote[] | undefined,
    }
  },
  async mounted() {
    if (!this.gameId) return

    const allGameRandomFactsRoundsResult = await this.$apollo
      .query({
        query: GAME_RANDOM_FACTS_ROUNDS_ALL_QUERY,
        variables: {
          gameId: this.gameId,
        },
        fetchPolicy: 'network-only',
      })
      .catch((error) => {
        this.graphqlError = error.message
        consola.error(error)
      })

    if (!allGameRandomFactsRoundsResult) return
    this.rounds = this.$util.getNested(
      allGameRandomFactsRoundsResult,
      'data',
      'allGameRandomFactsRounds',
      'nodes'
    ) as GameRandomFactsRound[]

    const leaderboardObject = {} as Record<string, number>

    for (const round of this.rounds) {
      const allGameRandomFactsVotesResult = await this.$apollo
        .query({
          query: GAME_RANDOM_FACTS_VOTES_ALL_QUERY,
          variables: {
            roundId: +round.id,
          },
          fetchPolicy: 'network-only',
        })
        .catch((error) => {
          this.graphqlError = error.message
          consola.error(error)
        })

      if (!allGameRandomFactsVotesResult) return
      this.votes = this.$util.getNested(
        allGameRandomFactsVotesResult,
        'data',
        'allGameRandomFactsVotes',
        'nodes'
      ) as GameRandomFactsVote[]

      for (const vote of this.votes) {
        if (!(vote.playerId in leaderboardObject)) {
          leaderboardObject[vote.playerId] = 0
        }

        if (vote.answer === round.answerCorrect) {
          leaderboardObject[vote.playerId] =
            leaderboardObject[vote.playerId] + 1
        }
      }
    }

    this.leaderboard = Object.entries(leaderboardObject).sort(
      ([, a], [, b]) => b - a
    )

    for (const [, value] of Object.values(this.leaderboard)) {
      if (
        this.highscores[this.highscores.length] === undefined &&
        (this.highscores.length === 0 ||
          this.highscores[this.highscores.length - 1] !== value)
      ) {
        this.highscores.push(value)
      }

      if (this.highscores.length === 3) break
    }
  },
})
</script>

<i18n lang="yml">
de:
  statisticNone: Keine Statistik vorhanden.
</i18n>
