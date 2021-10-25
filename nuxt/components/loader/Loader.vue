<template>
  <CardAlert
    v-if="errorMessage !== undefined"
    :error-message="String(errorMessage)"
  />
  <LoaderIndicatorText v-else />
</template>

<script lang="ts">
import { defineComponent, PropType } from '@nuxtjs/composition-api'

export default defineComponent({
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
