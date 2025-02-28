<template>
  <Loader
    v-if="($apollo.loading && !event) || graphqlError"
    :error-message="graphqlError ? String(graphqlError) : undefined"
  />
  <div v-else>
    <section class="mb-4 text-center">
      <h1>{{ $t('title') }}</h1>
      <div
        class="grid grid-cols-1 place-content-center gap-4 text-white lg:grid-cols-2"
      >
        <div class="flex-col rounded bg-gray-700 p-2">
          <div class="text-4xl">
            {{ numberFormat(donationAmountTeamSum) }}
          </div>
          <div class="font-bold">{{ $t('donationTeam') }}</div>
        </div>
        <div class="flex-col rounded bg-gray-700 p-2">
          <div class="text-4xl">
            {{
              numberFormat($util.getNested(event, 'commonDonationAmount') || 0)
            }}
          </div>
          <div class="font-bold">{{ $t('donationCommon') }}</div>
        </div>
        <div class="flex-col rounded bg-gray-700 p-4 lg:col-span-2">
          <div class="text-6xl">
            {{ numberFormat(donationAmountSum) }}
          </div>
          <div class="font-bold">{{ $t('donationTotal') }}</div>
        </div>
      </div>
    </section>
    <section>
      <h1 class="text-center">{{ $t('titleDistribution') }}</h1>
      <div class="overflow-auto">
        <table class="m-auto">
          <thead>
            <tr>
              <td />
              <th
                v-for="charityOrganization in charityOrganizations"
                :key="`header-${
                  $util.getNested(charityOrganization, 'id') || Math.random()
                }`"
                class="border border-gray-700 p-2"
              >
                {{ $util.getNested(charityOrganization, 'name') }}
              </th>
              <td />
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="(team, teamIndex) in [
                ...teams,
                {
                  name: 'Stream',
                  donationAmount: $util.getNested(
                    event,
                    'commonDonationAmount'
                  ),
                },
              ]"
              :key="team.id"
            >
              <th class="border border-gray-700 p-2 font-bold">
                {{ `${team.name}${team.emoji ? ' ' + team.emoji : ''}` }}
              </th>
              <td
                v-for="(
                  charityOrganization, charityOrganizationIndex
                ) in charityOrganizations"
                :key="`data-${
                  $util.getNested(charityOrganization, 'id') || Math.random()
                }`"
                class="border border-gray-700 p-2"
                :class="{
                  'font-bold':
                    $util.getNested(
                      team,
                      'charityOrganizationByCharityOrganizationId',
                      'id'
                    ) === $util.getNested(charityOrganization, 'id'),
                }"
              >
                {{
                  numberFormat(
                    $util.getNested(
                      distributionMatrix,
                      [teamIndex],
                      [charityOrganizationIndex]
                    )
                  )
                }}
              </td>
              <td class="border border-gray-700 p-2 font-bold">
                {{ numberFormat(team.donationAmount) }}
              </td>
            </tr>
            <tr>
              <td />
              <td
                v-for="(
                  charityOrganization, charityOrganizationIndex
                ) in charityOrganizations"
                :key="`total-${
                  $util.getNested(charityOrganization, 'id') || Math.random()
                }`"
                class="border border-gray-700 p-2 font-bold"
              >
                {{
                  numberFormat(
                    distributionMatrixTotalsVertical[charityOrganizationIndex]
                  )
                }}
              </td>
              <td class="border border-gray-700 p-2 font-bold">
                {{ numberFormat(donationAmountSum) }}
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>
  </div>
</template>

<script lang="ts">
import consola from 'consola'

import { defineComponent } from '#app'
import STATS_QUERY from '~/gql/query/stats.gql'
import { CharityOrganization } from '~/types/charityOrganization'
import { Team } from '~/types/team'

export default defineComponent({
  name: 'MaevsiDonation',
  props: {
    event: {
      type: Object,
      default: undefined,
    },
  },
  data() {
    return {
      DONATION_DISTRIBUTION_PERCENTAGE: 0.5,
      charityOrganizations: [] as CharityOrganization[],
      charityOrganizationWeigths: [] as number[],
      distributionMatrix: [] as Array<Array<any>>,
      distributionMatrixTotalsVertical: [] as number[],
      graphqlError: undefined,
      loading: true,
      teams: [] as Team[],
    }
  },
  computed: {
    donationAmountSum(): number {
      return (
        (this.$util.getNested(this.event, 'commonDonationAmount') || 0) +
        this.donationAmountTeamSum
      )
    },
    donationAmountTeamSum(): number {
      return this.teams.length
        ? this.teams.reduce(
            (previous, current) => previous + current.donationAmount,
            0
          )
        : 0
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
        const allTeams = this.$util.getNested(data, 'data', 'allTeams')
        const allGames = this.$util.getNested(data, 'data', 'allGames')
        const teamPlayerCount = this.$util.getNested(
          data,
          'data',
          'teamPlayerCount'
        )
        const donationsPerHead = []

        for (let i = 0; i < allTeams.nodes.length; i++) {
          const team = allTeams.nodes[i]
          const teamPlayerCountObject = teamPlayerCount.nodes[i]

          this.teams.push(team)
          this.charityOrganizations.push(
            team.charityOrganizationByCharityOrganizationId
          )
          donationsPerHead.push(
            typeof teamPlayerCountObject === 'undefined'
              ? 0
              : team.donationAmount / teamPlayerCountObject.playerCount
          )
        }

        const teamScores: number[] = []

        for (let i = 0; i < allGames.nodes.length; i++) {
          const game = allGames.nodes[i]

          for (let j = 0; j < game.gameTeamScoresByGameId.nodes.length; j++) {
            const teamScoreObject = game.gameTeamScoresByGameId.nodes[j]

            if (typeof teamScores[j] === 'undefined') {
              teamScores.push(teamScoreObject.score)
            } else {
              teamScores[j] = teamScores[j] + teamScoreObject.score
            }
          }
        }

        let donationsPerHeadLargest = 0

        for (let i = 0; i < donationsPerHead.length; i++) {
          if (donationsPerHead[i] > donationsPerHeadLargest) {
            donationsPerHeadLargest = donationsPerHead[i]
          }
        }

        const teamScoreNormalizeds: number[] = []

        for (let i = 0; i < teamScores.length; i++) {
          const teamScoreNormalized =
            (teamScores[i] / 100) *
            (100 / donationsPerHeadLargest) *
            donationsPerHead[i]
          teamScoreNormalizeds.push(teamScoreNormalized)
        }

        const teamScoresNormalizedSum = teamScoreNormalizeds.length
          ? teamScoreNormalizeds.reduce(
              (previous, current) => previous + current,
              0
            )
          : 0

        for (let i = 0; i < teamScoreNormalizeds.length; i++) {
          this.charityOrganizationWeigths.push(
            (1 / teamScoresNormalizedSum) * teamScoreNormalizeds[i]
          )
        }

        const teamsWithStream = [
          ...this.teams,
          {
            name: 'Stream',
            donationAmount: this.$util.getNested(
              this.event,
              'commonDonationAmount'
            ),
          },
        ]

        for (let i = 0; i < teamsWithStream.length; i++) {
          const team = teamsWithStream[i]
          const teamDonationWeighting =
            team.name === 'Stream' ? 1.0 : this.DONATION_DISTRIBUTION_PERCENTAGE

          if (typeof this.distributionMatrix[i] === 'undefined') {
            this.distributionMatrix.push([])
          }

          for (let j = 0; j < this.charityOrganizations.length; j++) {
            const charityOrganization = this.charityOrganizations[j]
            const teamCharityDonation =
              charityOrganization === null
                ? 0
                : team.donationAmount *
                    teamDonationWeighting *
                    this.charityOrganizationWeigths[j] +
                  (this.$util.getNested(
                    team,
                    'charityOrganizationByCharityOrganizationId',
                    'id'
                  ) === this.$util.getNested(charityOrganization, 'id')
                    ? team.donationAmount *
                      this.DONATION_DISTRIBUTION_PERCENTAGE
                    : 0)

            this.distributionMatrix[i].push(teamCharityDonation)

            if (
              typeof this.distributionMatrixTotalsVertical[j] === 'undefined'
            ) {
              this.distributionMatrixTotalsVertical.push(teamCharityDonation)
            } else {
              this.distributionMatrixTotalsVertical[j] += teamCharityDonation
            }
          }

          this.loading = false
        }
      })
      .catch((error) => {
        this.graphqlError = error.message
        consola.error(error)
      })
  },
  methods: {
    numberFormat(n: number) {
      return new Intl.NumberFormat('de-DE', {
        style: 'currency',
        currency: 'EUR',
      }).format(n)
    },
  },
})
</script>

<i18n lang="yml">
de:
  title: 'Spenden'
  titleDistribution: 'Spendenverteilung auf Organisationen'
  donationCommon: 'Stream-Spenden'
  donationTeam: 'Team-Spenden'
  donationTotal: 'Spenden insgesamt'
</i18n>
