<template>
  <CardAlert
    v-if="errorMessage !== undefined"
    :error-message="String(errorMessage)"
  />
  <LoaderIndicatorText v-else />
</template>

<script lang="ts">
import { defineComponent, PropType } from '#app'

export default defineComponent({
  name: 'MaevsiLoader',
  props: {
    errorMessage: {
      default: undefined,
      type: String as PropType<string | undefined>,
    },
    indicator: {
      default: undefined,
      type: String as PropType<string | undefined>,
    },
  },
})
</script>
