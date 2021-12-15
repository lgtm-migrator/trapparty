<template>
  <Loader
    v-if="$apollo.loading || graphqlError"
    :error-message="graphqlError ? String(graphqlError) : undefined"
  />
  <div v-else class="text-3xl lg:text-8xl text-justify">
    <div v-if="round && player">
      <span class="text-gray-500">Vor dir steht</span>
      {{ round.questionerName || $t('nobody')
      }}<span class="text-gray-500">. Welcher</span>
      random fact
      <span class="text-gray-500">ist wahr? 🤔</span>
      <div
        class="flex flex-col lg:flex-row gap-4 lg:gap-16 justify-evenly m-4 lg:m-16"
      >
        <Button
          :aria-label="$t('factA')"
          class="px-4 lg:px-16 py-8"
          :class="{
            'ring-8 ring-yellow-500': voteAnswer === 0,
            'bg-green-500':
              voteAnswer !== undefined && round.answerCorrect === 0,
          }"
          :disabled="voteAnswer !== undefined"
          @click="choose(0)"
        >
          {{ $t('factA') }}
        </Button>
        <Button
          :aria-label="$t('factB')"
          class="px-4 lg:px-16 py-8"
          :class="{
            'ring-8 ring-yellow-500': voteAnswer === 1,
            'bg-green-500':
              voteAnswer !== undefined && round.answerCorrect === 1,
          }"
          :disabled="voteAnswer !== undefined"
          @click="choose(1)"
        >
          {{ $t('factB') }}
        </Button>
      </div>
    </div>
    <div v-else>
      <span class="text-gray-500">Aktuell gibt es</span> keine Abstimmung<span
        class="text-gray-500"
        >.</span
      >
    </div>
  </div>
</template>

<script lang="ts">
import consola from 'consola'

import GAME_RANDOM_FACTS_VOTE_CREATE_MUTATION from '~/gql/mutation/game/createGameRandomFactsVote.gql'
import GAME_RANDOM_FACTS_ROUND_UPDATE_MUTATION from '~/gql/mutation/game/updateGameRandomFactsRoundById.gql'
import ALL_GAME_RANDOM_FACTS_ROUNDS_QUERY from '~/gql/query/game/allGameRandomFactsRounds.gql'
import GAME_RANDOM_FACTS_VOTE_BY_PLAYER_AND_ROUND_ID from '~/gql/query/game/gameRandomFactsVoteByPlayerIdAndRoundId.gql'
import PLAYER_BY_INVITATION_CODE_FN from '~/gql/query/player/playerByInvitationCodeFn.gql'
import { GameRandomFactsRound, Player } from '~/types/trapparty'

import { defineComponent } from '#app'

export default defineComponent({
  name: 'IndexPage',
  apollo: {
    allGameRandomFactsRounds() {
      return {
        query: ALL_GAME_RANDOM_FACTS_ROUNDS_QUERY,
        variables: {
          gameId: +this.gameId,
        },
        update: (data) =>
          this.$util.getNested(data, 'allGameRandomFactsRounds', 'nodes'),
        error(error: any) {
          this.graphqlError = error.message
          consola.error(error.message)
        },
      }
    },
  },
  props: {
    gameId: {
      required: true,
      type: Number,
    },
  },
  data() {
    return {
      graphqlError: undefined,
      player: undefined as Player | undefined,
      voteAnswer: undefined as number | undefined,
    }
  },
  computed: {
    name(): string | undefined {
      return this.$util.getNested(this.$store.state.participationData, 'name')
    },
    round() {
      if (!this.allGameRandomFactsRounds) return

      const roundsActive = (
        this.allGameRandomFactsRounds as GameRandomFactsRound[]
      ).filter(
        (x: GameRandomFactsRound) => x.answerCorrect === null
      ) as GameRandomFactsRound[]

      if (roundsActive.length > 1) {
        consola.error('There are more than one active rounds!')
      }

      return roundsActive[0]
    },
  },
  async mounted() {
    const invitationCode = this.$util.getNested(
      this.$store.state.participationData,
      'invitationCode'
    )

    if (!invitationCode) return

    const playerByInvitationCodeResult = await this.$apollo
      .query({
        query: PLAYER_BY_INVITATION_CODE_FN,
        variables: {
          invitationCode,
        },
      })
      .catch((error) => {
        this.graphqlError = error.message
        consola.error(error)
      })

    if (!playerByInvitationCodeResult) return
    this.player = this.$util.getNested(
      playerByInvitationCodeResult,
      'data',
      'playerByInvitationCodeFn',
      'nodes'
    )[0] as Player

    await this.voteFetch()
  },
  methods: {
    async choose(answer: number) {
      await this.refresh()

      if (!this.player || !this.round || this.round.answerCorrect !== null)
        return

      await this.$apollo
        .mutate({
          mutation: GAME_RANDOM_FACTS_VOTE_CREATE_MUTATION,
          variables: {
            gameRandomFactsVoteInput: {
              answer,
              playerId: +this.player.id,
              roundId: +this.round.id,
            },
          },
        })
        .then(async () => {
          if (!this.player || !this.round) return

          if (this.player.name !== this.round.questionerName) {
            this.$swal({
              icon: 'success',
              showConfirmButton: false,
              timer: 1500,
              text: this.$t('saved') as string,
            })
            await this.voteFetch()
          }
        })
        .catch((reason) => {
          this.$swal({
            icon: 'error',
            title: this.$t('error'),
            text: reason,
          })
          this.graphqlError = reason
          consola.error(reason)
        })

      if (this.player.name === this.round.questionerName) {
        await this.$apollo
          .mutate({
            mutation: GAME_RANDOM_FACTS_ROUND_UPDATE_MUTATION,
            variables: {
              gameRandomFactsRoundPatch: {
                answerCorrect: answer,
              },
              id: +this.round.id,
            },
          })
          .then(async () => {
            this.$swal({
              icon: 'success',
              showConfirmButton: false,
              timer: 1500,
              text: this.$t('saved') as string,
            })
            await this.voteFetch()
          })
          .catch((reason) => {
            this.$swal({
              icon: 'error',
              title: this.$t('error'),
              text: reason,
            })
            this.graphqlError = reason
            consola.error(reason)
          })
      }
    },
    async refresh() {
      await this.$apollo.queries.allGameRandomFactsRounds.refetch()
    },
    async voteFetch() {
      if (!this.player || !this.round) return

      const voteResult = await this.$apollo
        .query({
          query: GAME_RANDOM_FACTS_VOTE_BY_PLAYER_AND_ROUND_ID,
          variables: {
            playerId: this.player.id,
            roundId: this.round.id,
          },
          fetchPolicy: 'network-only',
        })
        .catch((error) => {
          this.graphqlError = error.message
          consola.error(error)
        })

      if (!voteResult) return
      this.voteAnswer = this.$util.getNested(
        voteResult,
        'data',
        'gameRandomFactsVoteByPlayerIdAndRoundId',
        'answer'
      ) as number
    },
  },
})
</script>

<i18n lang="yml">
de:
  check: Überprüfen
  factA: Fakt A
  factB: Fakt B
  nobody: niemand
  roundNew: Neue Runde!
  saved: Gespeichert.
</i18n>
