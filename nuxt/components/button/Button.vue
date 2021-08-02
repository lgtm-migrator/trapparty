<template>
  <span class="text-center">
    <AppLink
      v-if="to"
      :append="append"
      :aria-label="ariaLabel"
      :class="['button', ...(buttonClass ? [buttonClass] : [])].join(' ')"
      :disabled="disabled"
      :to="to"
    >
      <FontAwesomeIcon
        v-if="iconId"
        :class="{ 'mr-2': $slots.default }"
        :icon="iconId"
      />
      <slot />
    </AppLink>
    <button
      v-else
      :aria-label="ariaLabel"
      :class="['button', ...(buttonClass ? [buttonClass] : [])].join(' ')"
      :disabled="disabled"
      :type="type"
      @click="$emit('click')"
    >
      <FontAwesomeIcon
        v-if="iconId"
        :class="{ 'mr-2': $slots.default }"
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
      default: false,
      type: Boolean,
    },
    ariaLabel: {
      required: true,
      type: String,
    },
    buttonClass: {
      default: undefined,
      type: String,
    },
    disabled: {
      default: false,
      type: Boolean,
    },
    iconId: {
      default: undefined,
      type: Array,
    },
    to: {
      default: undefined,
      type: String,
    },
    type: {
      default: 'button',
      type: String,
    },
  },
}
</script>
