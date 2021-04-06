<template>
  <span class="inline-block">
    <AppLink
      v-if="link !== undefined"
      :append="append"
      :class="['button', ...(buttonClass ? [buttonClass] : [])].join(' ')"
      :disabled="disabled"
      :to="link"
    >
      <FontAwesomeIcon
        v-if="icon"
        :class="{ 'mr-2': this.$slots.default }"
        :icon="iconId"
      />
      <slot />
    </AppLink>
    <button
      v-else
      :class="`button ${buttonClass}`"
      :disabled="disabled"
      :type="type"
      @click="$emit('click')"
    >
      <FontAwesomeIcon
        v-if="icon"
        :class="{ 'mr-2': this.$slots.default }"
        :icon="iconId"
      />
      <slot />
    </button>
  </span>
</template>

<script>
export default {
  props: {
    append: {
      type: Boolean,
      default: false,
    },
    buttonClass: {
      type: String,
      default: undefined,
      // 'bg-red-600 disabled:bg-red-600 hover:bg-red-700 text-white',
      // 'bg-white disabled:bg-gray-500 hover:bg-gray-600 text-gray-900',
    },
    disabled: {
      type: Boolean,
      default: false,
    },
    icon: {
      type: Boolean,
      default: true,
    },
    iconId: {
      type: Array,
      default() {
        return ['fas', 'bug']
      },
    },
    link: {
      type: String,
      default: undefined,
    },
    type: {
      type: String,
      default: 'button',
    },
  },
}
</script>
