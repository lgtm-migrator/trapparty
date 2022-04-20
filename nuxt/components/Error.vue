<template>
  <div>
    <h1>{{ statusCode ? `${statusCode} - ` : '' }}{{ statusReason }}</h1>
    <p v-if="statusCode === 403" class="text-center">
      {{ $t('403description') }}
      <br />
      {{ $t('403hint') }}
    </p>
    <ButtonHome />
  </div>
</template>

<script lang="ts">
import { status } from '@http-util/status-i18n'
import { defineComponent, PropType } from '#app'

export default defineComponent({
  name: 'MaevsiError',
  props: {
    statusCode: {
      default: undefined,
      type: Number as PropType<number | undefined>,
    },
  },
  computed: {
    statusReason(): string {
      return (
        status(this.statusCode, this.$i18n.locale) ||
        (this.$t('error') as string)
      )
    },
  },
})
</script>

<i18n lang="yml">
de:
  403description: Du bist aktuell nicht berechtigt, auf diese Seite zuzugreifen.
  403hint: Hast du von diesem Gerät aus schon einen Einladungscode eingegeben oder dich angemeldet?
  error: Fehler
en:
  403description: "You're currently missing permissions to view this site."
  403hint: On this device, did you already enter an invitation code or sign in?
  error: Error
</i18n>
