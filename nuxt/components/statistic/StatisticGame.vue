<template>
  <div v-if="game">
    <div class="flex gap-2 items-center">
      <h2 class="m-0">{{ game.name }}</h2>
      <span class="bg-white px-2 py-1 rounded-full text-gray-900">
        {{ game.isActive ? $t('isActiveTrue') : $t('isActiveFalse') }}
      </span>
    </div>
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

<i18n lang="yml">
de:
  isActiveTrue: Aktiv
  isActiveFalse: Inaktiv
</i18n>
