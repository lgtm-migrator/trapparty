<template>
  <component
    :is="vertical ? chartBaseBarStacked : chartBaseBarStackedHorizontal"
    v-if="data"
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
      vertical: false,
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
        (this.vertical =
          e.target.outerWidth >= this.$global.CHART_DIRECTION_BREAKPOINT)
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
        const teamPlayerCount = this.$global.getNested(
          data,
          'data',
          'teamPlayerCount'
        )
        const labels = []
        const datasets = []
        const donationsPerHead = []
        const scoresTeam = []
        const scoresTeamTotal = []

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

        for (let i = 0; i < allGames.nodes.length; i++) {
          const game = allGames.nodes[i]

          for (let j = 0; j < game.gameScoresByGameId.nodes.length; j++) {
            const teamScoreObject = game.gameScoresByGameId.nodes[j]

            if (typeof scoresTeam[j] === 'undefined') {
              scoresTeam.push(teamScoreObject.score)
            } else {
              scoresTeam[j] = scoresTeam[j] + teamScoreObject.score
            }
          }
        }

        let donationsPerHeadLargest = 0

        for (let i = 0; i < donationsPerHead.length; i++) {
          if (donationsPerHead[i] > donationsPerHeadLargest) {
            donationsPerHeadLargest = donationsPerHead[i]
          }
        }

        for (let i = 0; i < scoresTeam.length; i++) {
          scoresTeamTotal.push(
            (scoresTeam[i] / 100) *
              (100 / donationsPerHeadLargest) *
              donationsPerHead[i]
          )
        }

        datasets.push({
          label: this.$t('title'),
          data: scoresTeamTotal,
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
        this.graphqlErrorMessage = error.message
        consola.error(error)
      })
  },
}
</script>

<i18n lang="yml">
de:
  title: Gesamtwertung
</i18n>
