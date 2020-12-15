<template>
  <Loader
    class="section-wrapper"
    :graphql-error-message="graphqlErrorMessage"
    :loading="$apollo.loading"
  >
    <div v-if="participationData">
      <section class="mt-8">
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
        <Button :icon-id="['fas', 'home']" :link="localePath('/')">
          {{ $t('home') }}
        </Button>
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
              class="mr-4"
              :icon-id="['fas', 'download']"
              link="https://discord.com/download"
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
              class="ml-4"
              :icon-id="['fas', 'sign-in-alt']"
              :link="`https://discord.gg/${participationData.teamByTeamId.eventByEventId.discordInviteCode}`"
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
            class="ml-4"
            :icon-id="['fab', 'youtube']"
            link="https://youtu.be/NJijHNL4yEo"
          >
            {{ $t('discordTutorial') }}
          </Button>
        </section>
        <section>
          <h3>{{ $t('donationTitle') }}</h3>
          <p>
            {{ $t('donationDescription') }}
            <span
              v-if="
                $global.getNested(
                  participationData,
                  'teamByTeamId',
                  'donationUrl'
                )
              "
            >
              {{ $t('donationDescriptionTeam') }}
            </span>
          </p>
          <i18n
            v-if="
              $global.getNested(
                participationData,
                'teamByTeamId',
                'charityOrganization',
                'name'
              )
            "
            path="teamDataCharityOrganisation"
          >
            <span class="font-bold">
              <a
                v-if="participationData.teamByTeamId.charityOrganization.url"
                :href="participationData.teamByTeamId.charityOrganization.url"
              >
                {{ participationData.teamByTeamId.charityOrganization.name }}
              </a>
              <span v-else class="inline-block">
                {{ participationData.teamByTeamId.charityOrganization.name }}
              </span>
            </span>
          </i18n>
          <p v-else>
            <span class="inline-block unready">
              {{ $t('teamDataCharityOrganisationDataless') }}
            </span>
          </p>
          <p>
            <Button
              v-if="
                $global.getNested(
                  participationData,
                  'teamByTeamId',
                  'donationUrl'
                )
              "
              :icon-id="['fas', 'heart']"
              :link="participationData.teamByTeamId.donationUrl"
            >
              {{ $t('donationButtonTeam') }}
            </Button>
            <span v-else class="inline-block unready">
              {{ $t('dataless', { what: $t('datalessDonationTeam') }) }}
            </span>
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
        <p>
          <Button
            v-if="$global.getNested(participationData, 'commonDonationUrl')"
            :icon-id="['fas', 'heart']"
            :link="participationData.commonDonationUrl"
          >
            {{ $t('donationButtonCommon') }}
          </Button>
          <span v-else class="inline-block unready">
            {{ $t('dataless', { what: $t('datalessDonationCommon') }) }}
          </span>
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
              class="mr-4"
              :icon-id="['fas', 'tv']"
              :link="event.streamUrl"
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
      </section>
    </div>
    <div v-else class="alert">
      {{ $t('participationDataless') }}
      <Button :icon-id="['fas', 'home']" :link="localePath('/')">
        {{ $t('home') }}
      </Button>
    </div>
  </Loader>
</template>

<script>
import __TYPENAME from '~/gql/query/__typename'
import ALL_EVENTS_NEWEST from '~/gql/query/allEventsNewest'
import PLAYER_BY_INVITATION_CODE_FN from '~/gql/query/playerByInvitationCodeFn'

const consola = require('consola')

export default {
  apollo: {
    participationData() {
      switch (this.$store.state.participationData.role) {
        case 'player':
          return {
            query: PLAYER_BY_INVITATION_CODE_FN,
            variables: {
              invitationCode: this.$store.state.participationData
                .invitationCode,
            },
            update: (data) =>
              this.$global.getNested(
                data,
                'playerByInvitationCodeFn',
                'nodes'
              )[0],
            error(error, _vm, _key, _type, _options) {
              this.graphqlErrorMessage = error.message
            },
          }
        case 'watcher':
          return {
            query: ALL_EVENTS_NEWEST,
            update: (data) =>
              this.$global.getNested(data, 'allEvents', 'nodes')[0],
            error(error, _vm, _key, _type, _options) {
              this.graphqlErrorMessage = error.message
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
      //     charityOrganization: {
      //       name: 'DRK',
      //       url: 'https://example.com',
      //     },
      //     donationUrl: 'https://example.com',
      //   },
      // },
      graphqlErrorMessage: undefined,
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
  datalessDiscordCode: 'Der Einladungscode für den Discord-Server'
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
  donationDescriptionTeam: 'Mit einem Klick auf den folgenden Button kannst du dich an der Spende deines Teams beteiligen.'
  errorUnexpectedParticipationRole: 'Error: Unexpected participation role!'
  home: 'Zurück zur Startseite'
  intentionDescription: 'Du hast dich entschieden, bei der kommenden TrapParty {0}.'
  intentionRoleAnonymous: 'anonym teilzunehmen'
  intentionRolePlayer: 'mitzumachen'
  participationDataless: 'Konnte keine Veranstaltungsdaten laden.'
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
  teamDataCharityOrganisationDataless: 'Ihr müsst euch noch auf eine Wohltätigkeitsorganisation einigen, an die eure Spenden gehen sollen.'
  teamDataTitle: 'Daten'
  title: "So funktioniert's"
</i18n>
