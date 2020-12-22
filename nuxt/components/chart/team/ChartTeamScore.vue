<template>
  <component
    :is="true ? chartBaseBarStacked : chartBaseBarStackedHorizontal"
    v-if="data !== null"
    :data="data"
    :options-additional="optionsComputed"
    :height="height"
  />
</template>

<script>
import merge from 'lodash.merge'

import ChartBaseBarStacked from '~/components/chart/base/ChartBaseBarStacked'
import ChartBaseBarStackedHorizontal from '~/components/chart/base/ChartBaseBarStackedHorizontal'
import STATS_QUERY from '~/gql/query/stats'

const Color = require('color')
const consola = require('consola')
const Rainbow = require('rainbowvis.js')

export default {
  props: {
    event: {
      type: Object,
      default: undefined,
    },
    height: {
      type: Number,
      default: undefined,
    },
    options: {
      type: Object,
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
      chartBaseBarStacked: ChartBaseBarStacked,
      chartBaseBarStackedHorizontal: ChartBaseBarStackedHorizontal,
      data: null,
      optionsDefault: {
        title: {
          text: this.$props.title,
        },
      },
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
        this.graphqlErrorMessage = error.message
        consola.error(error)
      })
  },
}
</script>

<i18n lang="yml">
de:
  title: Punkte
</i18n>
