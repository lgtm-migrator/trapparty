<template>
  <Loader
    :graphql-error-message="graphqlErrorMessage"
    :loading="$apollo.loading"
  >
    <h1>
      {{ eventData ? `Willkommen zur TrapParty ${eventData.name}!` : title }}
    </h1>
    <div v-if="eventData">
      <p>
        {{ $t('greeting') }}
      </p>
      <div
        class="items-center card flex flex-col lg:flex-row lg:flex-wrap my-8"
      >
        <Form class="lg:w-8/12" :validation-object="$v.form" @submit="saveCode">
          <h2>
            {{ $t('participate') }}
          </h2>
          <p>
            {{ $t('participateDescription') }}
          </p>
          <FormInput
            :error="$v.form['invitation-code'].$error"
            label-for="input-invitation-code"
            :title="$t('invitationCode')"
          >
            <input
              id="input-invitation-code"
              v-model.trim="invitationCodeModel"
              class="form-input"
              :disabled="$route.query.ic"
              type="text"
              placeholder="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
            />
            <template slot="inputInfo">
              <div v-if="$route.query.ic">
                Dieser Einladungscode wurde automatisch für dich eingegeben.
                <AppLink :to="localePath('/')">Code selbst eingeben.</AppLink>
              </div>
            </template>
            <template slot="inputError">
              <FormError
                :validation-object="$v.form['invitation-code']"
                validation-property="required"
              >
                {{ $t('globalValidationRequired') }}
              </FormError>
              <FormError
                :validation-object="$v.form['invitation-code']"
                validation-property="formatUuid"
              >
                {{ $t('globalValidationFormatIncorrect') }}
              </FormError>
            </template>
          </FormInput>
          <div class="flex flex-col items-center justify-between">
            <Button
              :disabled="
                !(
                  $v.form['invitation-code'].$dirty &&
                  !$v.form['invitation-code'].$error
                )
              "
              :icon="false"
              :title="
                !(
                  $v.form['invitation-code'].$dirty &&
                  !$v.form['invitation-code'].$error
                )
                  ? $t('formIncomplete')
                  : undefined
              "
              type="submit"
            >
              {{ $t('save') }}
            </Button>
          </div>
        </Form>
        <div class="self-stretch lg:w-1/12 px-8 py-8">
          <div class="border border-gray-300 h-0 lg:h-full w-full lg:w-0" />
        </div>
        <Form class="lg:w-2/12" @submit="anonymous">
          <h2>
            {{ $t('anonymousTitle') }}
          </h2>
          <p>
            {{ $t('anonymousDescription') }}
          </p>
          <div class="flex flex-col items-center justify-between">
            <Button class="m-4" :icon="false" type="submit">
              {{ $t('anonymous') }}
            </Button>
          </div>
        </Form>
        <p class="opacity-50 text-center text-sm w-full">
          {{ $t('disclaimer') }}
        </p>
      </div>
    </div>
    <div v-else class="info">
      {{ $t('datalessEvent') }}
    </div>
    <i18n class="prose" path="description" tag="p">
      <AppLink to="https://jonas-thelemann.de" :title="$t('titleAuthorLink')">
        Jonas Thelemann
      </AppLink>
    </i18n>
  </Loader>
</template>

<script>
import { required } from 'vuelidate/lib/validators'

import ALL_EVENTS_NEWEST from '~/gql/query/allEventsNewest'

export default {
  apollo: {
    eventData() {
      return {
        query: ALL_EVENTS_NEWEST,
        update: (data) => this.$global.getNested(data, 'allEvents', 'nodes')[0],
        error(error, _vm, _key, _type, _options) {
          this.graphqlErrorMessage = error.message
        },
      }
    },
  },
  data() {
    return {
      // eventUpcoming: {
      //   name: 'Nächste Party',
      //   start: 'bald',
      // },
      form: {
        'invitation-code':
          this.$route.query.ic === undefined ? undefined : this.$route.query.ic,
      },
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
    invitationCodeModel: {
      get() {
        return this.$route.query.ic !== undefined
          ? this.$route.query.ic
          : this.$v.form['invitation-code'].$model
      },
      set(value) {
        this.$v.form['invitation-code'].$model = value
      },
    },
  },
  mounted() {
    if (this.$route.query.ic !== undefined) {
      this.$v.form['invitation-code'].$touch()
    }
  },
  methods: {
    anonymous(e) {
      e.preventDefault()
      this.$store.commit('setParticipationData', { role: 'watcher' })
      this.$router.push({
        path: this.localePath(`/instructions`),
      })
    },
    saveCode(e) {
      e.preventDefault()
      this.$v.form.$reset()
      this.$store.commit('setParticipationData', {
        role: 'player',
        invitationCode: this.form['invitation-code'],
      })
      this.$router.push({
        path: this.localePath(`/instructions`),
      })
    },
  },
  validations() {
    return {
      form: {
        'invitation-code': {
          required,
          formatUuid: this.$global.VERIFICATION_FORMAT_UUID,
        },
      },
    }
  },
}
</script>

<i18n lang="yml">
de:
  2020: '2020'
  anonymous: 'Anonym teilnehmen'
  anonymousDescription: 'Du bist in keinem Team?'
  anonymousTitle: '👻'
  datalessEvent: 'Aktuell sind keine Daten für eine kommende TrapParty vorhanden.'
  description: 'Die TrapParty ist eine große Feier, die seit 2017 jährlich von {0} zum Anlass seines Geburtstags veranstaltet wird. Sie hat das Ziel, den Gästen Freude zu bereiten und ein wohliges Gemeinschaftsgefühl zu schaffen. Auf dieser Seite findest du alle Informationen über diese Feier, die von einigen auch "beste Party des Jahres" genannt wird. Naja, Jonas veranstaltet die Feier ja auch immer kurz vor Weihnachten, wie soll denn da auch noch eine andere Feier diesen Titel strittig machen.'
  formIncomplete: 'Formular unvollständig.'
  greeting: 'Schön, dass du da bist! 😊 Jetzt kann es losgehen.'
  invitationCode: 'Einladungscode'
  participate: 'Mitmachen'
  participateDescription: 'Die Standard-Wahl für alle eingeladenen Gäste. Volle Power ins Abenteuer! 🥳🚀'
  redeemSuccess: 'Einladungscode erfolgreich gespeichert.'
  save: 'Zu meiner Übersichtsseite'
  disclaimer: 'Für die kommende Veranstaltung sind Coronaschutzmaßnahmen implementiert. Der Kontakt zu entsprechenden Behörden besteht.'
  title: 'Willkommen!'
  titleAuthorLink: 'Jonas Website'
</i18n>
