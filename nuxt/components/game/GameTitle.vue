<template>
  <section
    class="flex flex-col-reverse items-start md:flex-row md:items-center md:gap-2"
  >
    <h1 class="m-0">{{ game.name }}</h1>
    <span
      class="rounded-full px-2 py-1 text-gray-900"
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
