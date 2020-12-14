<template>
  <div v-if="full" class="card">
    <slot />
  </div>
  <span v-else class="card inline-block">
    <slot />
  </span>
</template>

<script>
export default {
  props: {
    full: {
      type: Boolean,
      default: false,
    },
  },
}
</script>
