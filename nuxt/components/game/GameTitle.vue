<template>
  <section class="flex gap-2 items-center">
    <h1 class="m-0">{{ game.name }}</h1>
    <span
      class="px-2 py-1 rounded-full text-gray-900"
      :class="game.isActive ? 'bg-green-400' : 'bg-white'"
    >
      {{ game.isActive ? $t('isActiveTrue') : $t('isActiveFalse') }}
    </span>
  </section>
</template>

<script lang="ts">
import { defineNuxtComponent, PropType } from '@nuxt/bridge/dist/runtime'

import { Game } from '~/types/trapparty'

export default defineNuxtComponent({
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
