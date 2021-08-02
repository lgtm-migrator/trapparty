<template>
  <a
    v-if="to.match(/^(http(s)?|ftp):\/\//)"
    :href="to"
    :rel="
      [...(nofollow ? ['nofollow'] : []), 'noopener', 'noreferrer'].join(' ')
    "
    target="_blank"
    @click="$emit('click')"
  >
    <slot />
  </a>
  <nuxt-link v-else :append="append" :to="to" @click.native="$emit('click')">
    <slot />
  </nuxt-link>
</template>

<script>
export default {
  props: {
    append: {
      default: false,
      type: Boolean,
    },
    nofollow: {
      default: false,
      type: Boolean,
    },
    to: {
      required: true,
      type: String,
    },
  },
}
</script>
