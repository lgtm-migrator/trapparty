<template>
  <span>
    <span v-if="url">
      <slot />
      <Button
        :aria-label="$t('share')"
        :icon-id="['fas', 'share-alt']"
        @click="copy(url)"
      />
    </span>
    <span v-else class="inline-block unready">
      <slot name="unready" />
    </span>
    <Modal v-if="showModalCopySuccess" @close="showModalCopySuccess = false">
      {{ $t('donationUrlCopySuccess') }}
    </Modal>
  </span>
</template>

<script>
export default {
  props: {
    url: {
      type: String,
      default: undefined,
    },
  },
  data() {
    return {
      showModalCopySuccess: false,
    }
  },
  methods: {
    copy(string) {
      if (typeof window === 'undefined') {
        return
      }

      navigator.clipboard.writeText(string).then(
        () => {
          this.showModalCopySuccess = true
        },
        (_err) => {
          alert(this.$t('donationUrlCopyError'))
        }
      )
    },
  },
}
</script>

<i18n lang="yml">
de:
  donationUrlCopyError: 'Fehler: Der Spendenlink konnte leider nicht in die Zwischenablage kopiert werden!'
  donationUrlCopySuccess: 'Der Spendenlink wurde in die Zwischenablage kopiert.'
  share: Teilen
</i18n>
