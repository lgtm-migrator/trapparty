<template>
  <Button :aria-label="$t('readTag')" @click="nfcScan">
    {{ $t('nfcRead') }}
  </Button>
</template>

<script lang="ts">
import consola from 'consola'

import GAME_RANDOM_FACTS_ROUND_CREATE_MUTATION from '~/gql/mutation/game/createGameRandomFactsRound.gql'
import PLAYER_BY_INVITATION_CODE_FN from '~/gql/query/player/playerByInvitationCodeFn.gql'
import { Player } from '~/types/trapparty'

import { defineComponent } from '#app'

export default defineComponent({
  name: 'IndexPage',
  data() {
    return {
      graphqlError: undefined as any,
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
    async getPlayerByInvitationCode(invitationCode: string): Promise<Player> {
      const playerByInvitationCodeResult = await this.$apollo
        .query({
          query: PLAYER_BY_INVITATION_CODE_FN,
          variables: {
            invitationCode,
          },
        })
        .catch((error) => {
          this.graphqlError = error.message
          consola.error(error)
        })

      if (!playerByInvitationCodeResult)
        return Promise.reject(Error('No result for player by invitation code!'))
      return this.$util.getNested(
        playerByInvitationCodeResult,
        'data',
        'playerByInvitationCodeFn',
        'nodes'
      )[0] as Player
    },
    async gameRandomFactsRoundCreate(gameRandomFactsRoundInput: any) {
      const player = await this.getPlayerByInvitationCode(
        gameRandomFactsRoundInput.invitationCode
      )

      delete gameRandomFactsRoundInput.invitationCode
      gameRandomFactsRoundInput.questionerName = player.name

      await this.$apollo
        .mutate({
          mutation: GAME_RANDOM_FACTS_ROUND_CREATE_MUTATION,
          variables: {
            gameRandomFactsRoundInput,
          },
        })
        .then(() => {
          this.$swal({
            icon: 'success',
            showConfirmButton: false,
            timer: 1500,
          })
        })
        .catch((reason) => {
          this.$swal({
            icon: 'error',
            title: this.$t('error'),
            text: reason,
          })
          this.graphqlError = reason
          consola.error(reason)
        })
    },
    async nfcScan() {
      try {
        if (process.env.NODE_ENV === 'production') {
          const ndefReader = new NDEFReader()
          await ndefReader.scan()

          ndefReader.onreading = async (event: any) => {
            const decoder = new TextDecoder()

            for (const record of event.message.records) {
              await this.gameRandomFactsRoundCreate({
                gameId: +this.$route.params.gameId,
                invitationCode: decoder.decode(record.data),
                isActive: true,
              })
            }
          }
        } else {
          await this.gameRandomFactsRoundCreate({
            gameId: +this.$route.params.gameId,
            invitationCode: 'f10ea826-3c0d-11eb-805b-af16ca5c3a48',
            isActive: true,
          })
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

<i18n lang="yml">
de:
  nfcRead: NFC scannen
</i18n>
