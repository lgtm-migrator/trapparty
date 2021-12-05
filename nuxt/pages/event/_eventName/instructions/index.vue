<template>
  <Loader
    v-if="($apollo.loading && !participationData) || graphqlError"
    class="section-wrapper"
    :error-message="graphqlError ? String(graphqlError) : undefined"
  />
  <div v-else>
    <div v-if="participationData">
      <section class="mt-8 text-center">
        <span
          v-if="
            $store.state.participationData.role === 'player' &&
            $global.getNested(participationData, 'name')
          "
          class="text-2xl"
        >
          Hallo {{ participationData.name }}!
        </span>
        <h1>{{ title }}</h1>
      </section>
      <section class="info">
        <i18n path="intentionDescription">
          <span class="font-bold">{{ intention }}</span>
        </i18n>
        <ButtonHome />
      </section>
      <section
        v-if="$store.state.participationData.role === 'player'"
        class="prose"
      >
        <h2>{{ $t('teamTitle') }}</h2>
        <section>
          <h3>{{ $t('teamCommunicationTitle') }}</h3>
          <p>
            {{ $t('teamCommunicationDescription1') }}
            <i18n
              v-if="
                $global.getNested(participationData, 'teamByTeamId', 'name')
              "
              path="teamDataName"
            >
              <span class="font-bold">{{
                participationData.teamByTeamId.name
              }}</span>
            </i18n>
            <span v-else class="inline-block unready">
              {{ $t('teamDataNameDataless') }}
            </span>
          </p>
          <p>
            <Button
              :aria-label="$t('discordInstall')"
              class="mr-4"
              :icon-id="['fas', 'download']"
              to="https://discord.com/download"
            >
              {{ $t('discordInstall') }}
            </Button>
            <Button
              v-if="
                $global.getNested(
                  participationData,
                  'teamByTeamId',
                  'eventByEventId',
                  'discordInviteCode'
                )
              "
              :aria-label="$t('discordJoin')"
              class="ml-4"
              :icon-id="['fas', 'sign-in-alt']"
              :to="`https://discord.gg/${participationData.teamByTeamId.eventByEventId.discordInviteCode}`"
            >
              {{ $t('discordJoin') }}
            </Button>
            <span v-else class="inline-block unready">
              {{ $t('dataless', { what: $t('datalessDiscordCode') }) }}
            </span>
          </p>
          <p>
            {{
              $t('teamCommunicationDescription2', {
                emojiPrefix: participationData.teamByTeamId.emoji
                  ? participationData.teamByTeamId.emoji + '-'
                  : '',
              })
            }}
          </p>
          <Button
            :aria-label="$t('discordTutorial')"
            class="ml-4"
            :icon-id="['fab', 'youtube']"
            to="https://youtu.be/NJijHNL4yEo"
          >
            {{ $t('discordTutorial') }}
          </Button>
        </section>
        <section>
          <h3>{{ $t('donationTitle') }}</h3>
          <p>
            {{ $t('donationDescription') }}
            {{ $t('donationDescriptionTeam') }}
          </p>
          <i18n
            v-if="
              $global.getNested(
                participationData,
                'teamByTeamId',
                'charityOrganizationByCharityOrganizationId',
                'name'
              )
            "
            path="teamDataCharityOrganisation"
            tag="p"
          >
            <span class="font-bold">
              <a
                v-if="
                  participationData.teamByTeamId
                    .charityOrganizationByCharityOrganizationId.url
                "
                :href="
                  participationData.teamByTeamId
                    .charityOrganizationByCharityOrganizationId.url
                "
              >
                {{
                  participationData.teamByTeamId
                    .charityOrganizationByCharityOrganizationId.name
                }}
              </a>
              <span v-else class="inline-block">
                {{
                  participationData.teamByTeamId
                    .charityOrganizationByCharityOrganizationId.name
                }}
              </span>
            </span>
          </i18n>
          <p v-else>
            <span class="inline-block unready">
              {{ $t('teamDataCharityOrganisationDataless') }}
            </span>
          </p>
          <p
            v-if="
              $global.getNested(
                participationData,
                'teamByTeamId',
                'donationUrl'
              )
            "
          >
            <ButtonShare :url="participationData.teamByTeamId.donationUrl">
              <Button
                :aria-label="$t('donationButtonTeam')"
                :icon-id="['fas', 'heart']"
                :to="participationData.teamByTeamId.donationUrl"
              >
                {{ $t('donationButtonTeam') }}
              </Button>
              <template slot="unready">
                {{ $t('dataless', { what: $t('datalessDonationTeam') }) }}
              </template>
            </ButtonShare>
          </p>
        </section>
      </section>
      <section
        v-if="$store.state.participationData.role === 'watcher'"
        class="prose"
      >
        <h2>{{ $t('donationTitle') }}</h2>
        <p>
          {{ $t('donationDescription') }}
          {{ $t('donationDescriptionCommon') }}
        </p>
        <p v-if="$global.getNested(participationData, 'commonDonationUrl')">
          <ButtonShare :url="participationData.commonDonationUrl">
            <Button
              :aria-label="$t('donationButtonCommon')"
              :icon-id="['fas', 'heart']"
              :to="participationData.commonDonationUrl"
            >
              {{ $t('donationButtonCommon') }}
            </Button>
            <template slot="unready">
              {{ $t('dataless', { what: $t('datalessDonationCommon') }) }}
            </template>
          </ButtonShare>
        </p>
      </section>
      <section class="prose">
        <h2>{{ $t('streamTitle') }}</h2>
        <p>
          {{ $t('streamDescription') }}
          <span v-if="$store.state.participationData.role === 'player'">
            {{ $t('streamDescriptionPlayer') }}
          </span>
        </p>
        <p>
          <span v-if="$global.getNested(event, 'streamUrl')">
            <Button
              :aria-label="$t('streamGoto')"
              class="mr-4"
              :icon-id="['fas', 'tv']"
              :to="event.streamUrl"
            >
              {{ $t('streamGoto') }}
            </Button>
            <i18n
              v-if="$global.getNested(event, 'start')"
              path="streamDescriptionStart"
            >
              <span class="font-bold">
                {{ $moment(event.start).format('lll') }} ({{
                  $moment(event.start).fromNow()
                }})
              </span>
            </i18n>
          </span>
          <span v-else class="inline-block unready">
            {{ $t('dataless', { what: $t('datalessStream') }) }}
          </span>
        </p>
        <p>
          <Button
            append
            :aria-label="$t('statisticsGoTo')"
            class="mr-4"
            :icon-id="['fas', 'chart-bar']"
            to="../statistics"
          >
            {{ $t('statisticsGoTo') }}
          </Button>
        </p>
      </section>
    </div>
    <div v-else class="alert">
      {{ $t('participationDataless') }}
      <ButtonHome />
    </div>
  </div>
</template>

<script>
import consola from 'consola'

import __TYPENAME from '~/gql/query/__typename.gql'
import EVENT_BY_NAME from '~/gql/query/event/eventByName.gql'
import PLAYER_BY_INVITATION_CODE_FN from '~/gql/query/playerByInvitationCodeFn.gql'

export default {
  name: 'IndexPage',
  apollo: {
    participationData() {
      switch (this.$store.state.participationData.role) {
        case 'player':
          return {
            query: PLAYER_BY_INVITATION_CODE_FN,
            variables: {
              eventName: this.$route.params.eventName,
              participationCode:
                this.$store.state.participationData.participationCode,
            },
            update: (data) =>
              this.$global.getNested(
                data,
                'playerByInvitationCodeFn',
                'nodes'
              )[0],
            error(error, _vm, _key, _type, _options) {
              this.graphqlError = error.message
            },
          }
        case 'watcher':
          return {
            query: EVENT_BY_NAME,
            variables: {
              eventName: this.$route.params.eventName,
            },
            update: (data) => this.$global.getNested(data, 'eventByName'),
            error(error, _vm, _key, _type, _options) {
              this.graphqlError = error.message
            },
          }
        default:
          consola.error(this.$t('errorUnexpectedParticipationRole'))
          return {
            query: __TYPENAME,
          }
      }
    },
  },
  middleware({ app, store, redirect }) {
    if (store.state.participationData === null) {
      return redirect(app.localePath('/'))
    }
  },
  data() {
    return {
      // participationData: {
      //   eventByEventId: {
      //     discordInviteCode: '1234abcd',
      //     streamUrl: 'https://example.com',
      //     commonDonationUrl: 'https://example.com',
      //     start: 'bald',
      //   },
      //   name: 'Jonas',
      //   teamByTeamId: {
      //     name: 'Die Landratten',
      //     charityOrganizationByCharityOrganizationId: {
      //       name: 'DRK',
      //       url: 'https://example.com',
      //     },
      //     donationUrl: 'https://example.com',
      //   },
      // },
      graphqlError: undefined,
      title: this.$t('title'),
    }
  },
  head() {
    return {
      title: this.title,
    }
  },
  computed: {
    event() {
      switch (this.$store.state.participationData.role) {
        case 'player':
          return this.$global.getNested(
            this.participationData,
            'teamByTeamId',
            'eventByEventId'
          )
        case 'watcher':
          return this.participationData
        default:
          alert(this.$t('errorUnexpectedParticipationRole'))
      }

      return undefined
    },
    intention() {
      switch (this.$store.state.participationData.role) {
        case 'player':
          return this.$t('intentionRolePlayer')
        case 'watcher':
          return this.$t('intentionRoleAnonymous')
        default:
          alert(this.$t('errorUnexpectedParticipationRole'))
      }

      return undefined
    },
  },
}
</script>

<style scoped>
.section-wrapper > section {
  margin-bottom: 2rem;
}

.section-wrapper > section > section {
  margin-bottom: 1.5rem;
}
</style>

<i18n lang="yml">
de:
  dataless: '{what} ist noch nicht verfügbar.'
  datalessDiscordCode: 'Der Teilnahmecode für den Discord-Server'
  datalessDonationCommon: 'Der Link zur Spendenseite für Zuschauer ohne Team'
  datalessDonationTeam: 'Der Link zur Spendenseite deines Teams'
  datalessStream: 'Der Link zum Stream'
  discordInstall: 'Discord installieren'
  discordJoin: 'Server beitreten'
  discordTutorial: 'Videoanleitung vom Weihnachtsmann'
  donationButtonCommon: 'Für alle Organisationen spenden'
  donationButtonTeam: 'Zum Spendenkonto deines Teams'
  donationTitle: 'Gutes Tun ❤️'
  donationDescription: 'In diesem Jahr spenden wir gemeinsam für mehrere Organisationen.'
  donationDescriptionCommon: 'Da du angeklickt hast, dass du nur zuschauen möchtest, wird deine Spende gleichmäßig auf alle Organisationen verteilt, für die die verschiedenen Teams im Stream kämpfen!'
  donationDescriptionTeam: 'Im Stream könnt ihr mehr Spenden für die von euch gewählte wohltätige Organisation sammeln und müsst den von euch gesammelten Spendenbetrag verteidigen. Der von euch gesammelte Betrag kann also auch zu Teilen wohltätigen Organisationen zugutekommen, die anderen Teams am Herzen liegen.'
  errorUnexpectedParticipationRole: 'Error: Unexpected participation role!'
  home: 'Zurück zur Startseite'
  intentionDescription: 'Du hast dich entschieden, bei der kommenden TrapParty {0}.'
  intentionRoleAnonymous: 'anonym teilzunehmen'
  intentionRolePlayer: 'mitzumachen'
  participationDataless: 'Konnte keine Veranstaltungsdaten laden.'
  statisticsGoTo: 'Zu den Statistiken'
  streamTitle: 'Zuschauen 📺'
  streamDescription: 'Es erwartet dich eine Late-Night-Show mit Spiel, Spaß und Spannung 🥳'
  streamDescriptionPlayer: 'Als Spieler schaust du den Stream während du gleichzeitig mit deinen Teammitgliedern auf Discord bist.'
  streamDescriptionStart: 'Geplanter Start: {0}'
  streamGoto: 'Zum Stream'
  teamCommunicationTitle: 'Kommunikation 📞'
  teamCommunicationDescription1: 'Für diese Veranstaltung wurde ein Discord-Server eingerichtet, über den alle Gäste mit ihren Teammitgliedern und anderen Teilnehmenden kommunizieren können.'
  teamCommunicationDescription2: 'Wenn du dem Server beigetreten bist, musst du im Textkanal "wähle-eine-gruppe" unter der einzigen Nachricht dort auf das {emojiPrefix}Emoji deines Teams klicken. Damit erhältst du Zugriff auf den Text- & Sprachkanal deines Teams, in denen du dich mit deinem Team austauschen kannst.'
  teamTitle: 'Dein Team 👪'
  teamDataless: 'Fehler: Teamdaten konnten nicht geladen werden!'
  teamDataName: 'Du bist im Team "{0}"!'
  teamDataNameDataless: 'Ihr müsst euch noch auf einen eigenen Teamnamen einigen.'
  teamDataCharityOrganisation: 'Ihr spendet für {0}.'
  teamDataCharityOrganisationDataless: 'Ihr müsst euch noch auf eine Wohltätigkeitsorganisation einigen, für die ihr Spenden sammeln wollt.'
  teamDataTitle: 'Daten'
  title: "So funktioniert's"
</i18n>
