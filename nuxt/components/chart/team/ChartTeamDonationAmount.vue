<template>
  <ChartBaseBar
    v-if="data"
    :data="data"
    :height="height"
    :horizontal="horizontal"
    :options-additional="optionsComputed"
  />
</template>

<script lang="ts">
import { ChartData, ChartOptions } from 'chart.js'
import Color from 'color'
import consola from 'consola'
import merge from 'lodash.merge'
import Rainbow from 'rainbowvis.js'

import { defineComponent, PropType } from '#app'
import { Event as TrapPartyEvent } from '~/types/trapparty'
import STATS_QUERY from '~/gql/query/stats.gql'

export default defineComponent({
  props: {
    event: {
      type: Object as PropType<TrapPartyEvent>,
      default: undefined,
    },
    height: {
      type: Number,
      default: undefined,
    },
    options: {
      type: Object as PropType<ChartOptions<'bar'>>,
      default: undefined,
    },
    title: {
      type: String,
      default() {
        return this.$t('title')
      },
    },
  },
  data() {
    return {
      data: null as ChartData<'bar'> | null,
      horizontal: true,
      optionsDefault: {
        plugins: {
          title: {
            text: this.$props.title,
          },
        },
      } as ChartOptions<'bar'>,
    }
  },
  computed: {
    optionsComputed() {
      return merge(this.optionsDefault, this.optionsAdditional)
    },
  },
  mounted() {
    if (!this.event) {
      return
    }

    window.addEventListener('resize', (e) => {
      this.horizontal =
        (e?.target as Window).outerWidth < this.$util.CHART_DIRECTION_BREAKPOINT
    })

    window.dispatchEvent(new Event('resize'))

    this.$apollo
      .query({
        query: STATS_QUERY,
        variables: {
          eventId: this.event.id,
        },
      })
      .then((data) => {
        const rainbow = new Rainbow()
        const allTeams = this.$util.getNested(data, 'data', 'allTeams')
        const teamPlayerCount = this.$util.getNested(
          data,
          'data',
          'teamPlayerCount'
        )
        const labels = []
        const datasets = []
        const donationsPerHead = []

        for (let i = 0; i < allTeams.nodes.length; i++) {
          const team = allTeams.nodes[i]
          const teamPlayerCountObject = teamPlayerCount.nodes[i]

          labels.push(`${team.name} ${team.emoji}`)
          donationsPerHead.push(
            typeof teamPlayerCountObject === 'undefined'
              ? 0
              : team.donationAmount / teamPlayerCountObject.playerCount
          )
        }

        datasets.push({
          label: this.$t('title') as string,
          data: donationsPerHead,
          backgroundColor: Color(`#${rainbow.colorAt(0)}`)
            .desaturate(0.5)
            .darken(0.25)
            .hex(),
        })

        this.data = {
          labels,
          datasets,
        }
      })
      .catch((error) => {
        this.graphqlError = error.message
        consola.error(error)
      })
  },
})
</script>

<i18n lang="yml">
de:
  title: Spenden pro Kopf
</i18n>
