<template>
  <div class="text-3xl lg:text-8xl text-justify">
    <div v-if="name && score !== undefined">
      <span class="text-gray-500">Du bist</span> {{ name
      }}<span class="text-gray-500">, du hast</span> {{ score }} Punkte<span
        class="text-gray-500"
        >.</span
      >
    </div>
    <div v-if="round">
      <span class="text-gray-500">Vor dir steht</span>
      {{ questionerName || $t('nobody')
      }}<span class="text-gray-500">. Welcher</span>
      random fact
      <span class="text-gray-500">ist wahr? 🤔</span>
      <div
        class="flex flex-col lg:flex-row gap-4 lg:gap-16 justify-evenly m-4 lg:m-16"
      >
        <Button class="px-4 lg:px-16 py-8">Fact A</Button>
        <Button class="px-4 lg:px-16 py-8">Fact B</Button>
      </div>
    </div>
    <div v-else>
      <span class="text-gray-500">Aktuell gibt es</span> keine Abstimmung<span
        class="text-gray-500"
        >.</span
      >
    </div>
  </div>
</template>

<script lang="ts">
import consola from 'consola'

import PLAYER_BY_INVITATION_CODE_FN from '~/gql/query/playerByInvitationCodeFn.gql'

import { defineComponent } from '#app'

export default defineComponent({
  name: 'IndexPage',
  apollo: {
    participationData() {
      return {
        query: PLAYER_BY_INVITATION_CODE_FN,
        variables: {
          eventName: '2021',
          invitationCode: this.$store.state.participationData.invitationCode,
        },
        update: (data) =>
          this.$util.getNested(data, 'playerByInvitationCodeFn', 'nodes')[0],
        error(error: any) {
          this.graphqlError = error.message
          consola.error(error.message)
        },
      }
    },
  },
  middleware({ app, store, redirect }) {
    if (
      !store.state.participationData ||
      store.state.participationData.role !== 'player'
    ) {
      return redirect(app.localePath('/'))
    }
  },
  data() {
    return {
      graphqlError: undefined,
      // questionerName: 'Jonas Thelemann',
      round: undefined,
      score: 0,
      title: this.$t('title'),
    }
  },
  head() {
    return {
      title: this.title,
    }
  },
  computed: {
    name() {
      if (!this.participationData) return
      return this.participationData.name
    },
  },
})
</script>

<i18n lang="yml">
de:
  nobody: niemand
  title: Spiel
</i18n>
