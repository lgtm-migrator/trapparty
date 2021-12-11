<template>
  <div v-if="game">
    <GameTitle :game="game" />
    <StatisticGameRandomFact
      v-if="game.type === 'RANDOM_FACTS'"
      :game-id="+game.id"
    />
  </div>
</template>

<script lang="ts">
import { defineComponent, PropType } from '#app'
import { Game } from '~/types/trapparty'

export default defineComponent({
  props: {
    game: {
      required: true,
      type: Object as PropType<Game>,
    },
  },
})
</script>
