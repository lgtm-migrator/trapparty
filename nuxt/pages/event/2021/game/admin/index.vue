<template>
  <Button aria-label="Read NFC" @click="onClick">Read NFC</Button>
</template>

<script lang="ts">
import consola from 'consola'

import { defineComponent } from '#app'

export default defineComponent({
  name: 'IndexPage',
  data() {
    return {
      isNfcWritableErrorMessage: undefined as string | undefined,
    }
  },
  mounted() {
    this.checkNfcErrors().catch((err: Error) => {
      this.isNfcWritableErrorMessage = err.message
    })
  },
  methods: {
    async checkNfcErrors(): Promise<void> {
      if (!('NDEFReader' in window)) {
        return Promise.reject(Error('Web NFC is not supported!'))
      }

      if (!navigator.permissions) {
        return Promise.reject(Error('Navigator permissions are not supported!'))
      } else {
        const nfcPermissionStatus = await navigator.permissions.query({
          name: 'nfc' as PermissionName,
        })

        if (nfcPermissionStatus.state === 'granted') {
          return Promise.resolve()
        } else {
          return Promise.reject(Error(nfcPermissionStatus.state))
        }
      }
    },
    async onClick() {
      await (this.readTag as Function)()
    },
    async readTag() {
      try {
        const ndefReader = new NDEFReader()
        await ndefReader.scan()

        ndefReader.onreading = (event: any) => {
          this.$swal({
            icon: 'success',
            showConfirmButton: false,
            timer: 1500,
          })
          const decoder = new TextDecoder()
          for (const record of event.message.records) {
            alert('Record type:  ' + record.recordType)
            alert('MIME type:    ' + record.mediaType)
            alert('=== data ===\n' + decoder.decode(record.data))
          }
        }
      } catch (error) {
        if (error instanceof DOMException) {
          const errorMessage: string = error.message

          this.$swal({
            icon: 'error',
            text: errorMessage,
            title: this.$t('globalStatusError'),
          })
          consola.error(errorMessage)
        } else {
          alert(`Unexpected error: ${error}`)
        }
      }
    },
  },
})
</script>
