<template>
  <div
    v-if="
      graphqlErrorMessage !== null &&
      (validationObject === undefined || !validationObject.$anyDirty)
    "
    class="alert"
    role="alert"
  >
    <span>
      {{ 'Error: ' + graphqlErrorMessage.replace('GraphQL error: ', '') }}
    </span>
  </div>
</template>

<script>
export default {
  props: {
    graphqlErrorMessage: {
      type: String,
      default: null,
    },
    validationObject: {
      type: Object,
      default: undefined,
    },
  },
}
</script>
