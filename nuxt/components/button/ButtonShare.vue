<template>
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
</template>

<script lang="ts">
import { defineComponent } from '#app'

export default defineComponent({
  props: {
    url: {
      type: String,
      default: undefined,
    },
  },
  methods: {
    copy(string: string) {
      if (typeof window === 'undefined') {
        return
      }

      navigator.clipboard.writeText(string).then(
        () => {
          this.$swal({
            icon: 'success',
            showConfirmButton: false,
            timer: 1500,
            title: this.$t('donationUrlCopySuccess'),
          })
        },
        (_err) => {
          alert(this.$t('donationUrlCopyError'))
        }
      )
    },
  },
})
</script>

<i18n lang="yml">
de:
  donationUrlCopyError: 'Fehler: Der Spendenlink konnte leider nicht in die Zwischenablage kopiert werden!'
  donationUrlCopySuccess: 'Der Spendenlink wurde in die Zwischenablage kopiert.'
  share: Teilen
</i18n>
