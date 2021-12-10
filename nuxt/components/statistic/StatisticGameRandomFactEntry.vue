<template>
  <li
    class="bg-gray-700 p-2 rounded-sm"
    :class="{
      'border border-yellow-500':
        highscores[0] !== undefined && value === highscores[0],
      'border border-gray-500':
        highscores[1] !== undefined && value === highscores[1],
      'border border-yellow-700':
        highscores[2] !== undefined && value === highscores[2],
    }"
  >
    {{ playerNameById }}: {{ value }}
  </li>
</template>

<script lang="ts">
import consola from 'consola'

import PLAYER_NAME_BY_ID_QUERY from '~/gql/query/player/playerNameById.gql'

import { defineComponent, PropType } from '#app'

export default defineComponent({
  apollo: {
    playerNameById() {
      return {
        query: PLAYER_NAME_BY_ID_QUERY,
        variables: {
          id: this.playerId,
        },
        update: (data: any) => this.$util.getNested(data, 'playerNameById'),
        error(error: any) {
          consola.error(error)
          this.graphqlError = error.message
        },
      }
    },
  },
  props: {
    highscores: {
      required: true,
      type: Array as PropType<Array<Number>>,
    },
    playerId: {
      required: true,
      type: Number,
    },
    value: {
      required: true,
      type: Number,
    },
  },
  data() {
    return {
      graphqlError: undefined as string | undefined,
      playerNameById: undefined as string | undefined,
    }
  },
})
</script>

<i18n lang="yml">
de:
  gameRandomFactsRoundNone: Keine Spielrunde vorhanden.
  gameRandomFactsVoteNone: Keine Abstimmungen vorhanden.
</i18n>
