<template>
  <div
    v-if="
      (!formInput && !validationProperty) ||
      (formInput.$error &&
        validationProperty in formInput &&
        !formInput[validationProperty])
    "
    class="text-left text-red-600"
  >
    <FontAwesomeIcon
      v-if="formInput && validationProperty"
      :icon="['fas', 'exclamation-circle']"
    />
    <slot />
  </div>
</template>

<script lang="ts">
import { defineComponent, PropType } from '#app'

export default defineComponent({
  props: {
    formInput: {
      default: undefined,
      type: Object,
    },
    validationProperty: {
      default: undefined,
      type: String as PropType<string | undefined>,
    },
  },
})
</script>
