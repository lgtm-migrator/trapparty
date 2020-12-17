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
        <Form
          class="lg:w-8/12"
          :validation-object="$v.form"
          @submit="authenticate"
        >
          <h2>
            {{ $t('participate') }}
          </h2>
          <p>
            {{ $t('participateDescription') }}
          </p>
          <FormInput
            :error="$v.form['participation-code'].$error"
            label-for="input-participation-code-trapparty"
            :title="$t('participationCode')"
          >
            <!--
              The id's suffix `-trapparty` makes browser suggest inputs just
              for this service.
            -->
            <input
              id="input-participation-code-trapparty"
              v-model.trim="participationCodeModel"
              class="form-input"
              :disabled="$route.query.ic"
              type="text"
              placeholder="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
            />
            <template slot="inputInfo">
              <div v-if="$route.query.ic">
                {{ $t('participationCodeAutomatic') }}
                <AppLink :to="localePath('/')">{{
                  $t('participationCodeManual')
                }}</AppLink>
              </div>
            </template>
            <template slot="inputError">
              <FormError
                :validation-object="$v.form['participation-code']"
                validation-property="required"
              >
                {{ $t('globalValidationRequired') }}
              </FormError>
              <FormError
                :validation-object="$v.form['participation-code']"
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
                  $v.form['participation-code'].$dirty &&
                  !$v.form['participation-code'].$error
                )
              "
              :icon="false"
              :title="
                !(
                  $v.form['participation-code'].$dirty &&
                  !$v.form['participation-code'].$error
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
        <div class="lg:w-2/12">
          <h2>
            {{ $t('anonymousTitle') }}
          </h2>
          <p>
            {{ $t('anonymousDescription') }}
          </p>
          <div class="flex flex-col items-center justify-between">
            <Button
              class="m-4"
              :icon="false"
              :link="localePath('/instructions')"
              type="button"
            >
              {{ $t('anonymous') }}
            </Button>
          </div>
        </div>
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

import AUTHENTICATE_MUTATION from '~/gql/mutation/authenticate'
import ALL_EVENTS_NEWEST_QUERY from '~/gql/query/allEventsNewest'

const consola = require('consola')

export default {
  apollo: {
    eventData() {
      return {
        query: ALL_EVENTS_NEWEST_QUERY,
        update: (data) => this.$global.getNested(data, 'allEvents', 'nodes')[0],
        error(error, _vm, _key, _type, _options) {
          this.graphqlErrorMessage = error.message
        },
      }
    },
  },
  data() {
    return {
      form: {
        'participation-code':
          this.$route.query.ic === undefined ? undefined : this.$route.query.ic,
      },
      formSent: undefined,
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
    participationCodeModel: {
      get() {
        return this.$route.query.ic !== undefined
          ? this.$route.query.ic
          : this.$v.form['participation-code'].$model
      },
      set(value) {
        this.$v.form['participation-code'].$model = value
      },
    },
  },
  mounted() {
    if (this.$route.query.ic !== undefined) {
      this.$v.form['participation-code'].$touch()
    }
  },
  methods: {
    async authenticate(e) {
      e.preventDefault()

      this.formSent = true
      this.graphqlErrorMessage = undefined

      this.$v.form.$reset()
      const res = await this.$apollo
        .mutate({
          mutation: AUTHENTICATE_MUTATION,
          variables: {
            participationCode: this.form['participation-code'],
          },
        })
        .then(({ data }) => this.$global.getNested(data, 'authenticate'))
        .catch((error) => {
          this.graphqlErrorMessage = error.message
          consola.error(error)
        })

      if (!res) {
        return
      }

      this.$global.storeJwt(
        this.$apollo.getClient(),
        this.$store,
        undefined,
        res.jwt
      )
    },
  },
  validations() {
    return {
      form: {
        'participation-code': {
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
  participationCode: 'Teilnahmecode'
  participationCodeAutomatic: 'Der Teilnahmecode wurde automatisch für dich eingegeben.'
  participationCodeManual: 'Code selbst eingeben.'
  participate: 'Mitmachen'
  participateDescription: 'Die Standard-Wahl für alle eingeladenen Gäste. Volle Power ins Abenteuer! 🥳🚀'
  save: 'Zu meiner Übersichtsseite'
  disclaimer: 'Für die kommende Veranstaltung sind Coronaschutzmaßnahmen implementiert. Der Kontakt zu entsprechenden Behörden besteht.'
  title: 'Willkommen!'
  titleAuthorLink: 'Jonas Website'
</i18n>
