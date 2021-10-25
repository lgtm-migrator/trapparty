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
import { defineComponent, PropType } from '@vue/composition-api'
import { ChartData, ChartOptions } from 'chart.js'
import merge from 'lodash.merge'

import { Event as TrapPartyEvent } from '~/types/event'
import STATS_QUERY from '~/gql/query/stats.gql'

const Color = require('color')
const consola = require('consola')
const Rainbow = require('rainbowvis.js')

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

    window.addEventListener(
      'resize',
      (e) =>
        (this.horizontal =
          (e?.target as Window).outerWidth <
          this.$global.CHART_DIRECTION_BREAKPOINT)
    )

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
        const allTeams = this.$global.getNested(data, 'data', 'allTeams')
        const allGames = this.$global.getNested(data, 'data', 'allGames')
        const labels = []
        const datasets = []

        for (let i = 0; i < allTeams.nodes.length; i++) {
          const team = allTeams.nodes[i]
          labels.push(`${team.name} ${team.emoji}`)
        }

        for (let i = 0; i < allGames.nodes.length; i++) {
          const game = allGames.nodes[i]
          const scores = []

          for (let j = 0; j < game.gameScoresByGameId.nodes.length; j++) {
            const teamScoreObject = game.gameScoresByGameId.nodes[j]
            scores.push(teamScoreObject.score)
          }

          datasets.push({
            label: game.name,
            data: scores,
            backgroundColor: Color(
              `#${rainbow.colorAt((100 / (allGames.totalCount - 1)) * i)}`
            )
              .desaturate(0.5)
              .darken(0.25)
              .hex(),
          })
        }

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
  title: Punkte
</i18n>
