<template>
  <Loader
    v-if="($apollo.loading && !event) || graphqlError"
    :error-message="graphqlError ? String(graphqlError) : undefined"
  />
  <div v-else>
    <div class="text-center">
      <h1>
        {{ event ? `Willkommen zur TrapParty ${event.name}!` : title }}
      </h1>
      <div v-if="event">
        <p>
          {{ $t('greeting') }}
        </p>
        <div
          class="items-center card flex flex-col lg:flex-row lg:flex-wrap my-8"
        >
          <Form
            class="lg:w-8/12"
            :form="$v.form"
            :form-sent="form.sent"
            :submit-name="$t('save')"
            @submit.prevent="saveCode"
          >
            <h2>
              {{ $t('participate') }}
            </h2>
            <p>
              {{ $t('participateDescription') }}
            </p>
            <FormInput
              :error="$v.form.participationCode.$error"
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
                  <AppLink :to="localePath('/')">
                    {{ $t('participationCodeManual') }}
                  </AppLink>
                </div>
              </template>
              <template slot="inputError">
                <FormInputError
                  :form-input="$v.form.participationCode"
                  validation-property="required"
                >
                  {{ $t('globalValidationRequired') }}
                </FormInputError>
                <FormInputError
                  :form-input="$v.form.participationCode"
                  validation-property="formatUuid"
                >
                  {{ $t('globalValidationFormatIncorrect') }}
                </FormInputError>
              </template>
            </FormInput>
          </Form>
          <div class="self-stretch lg:w-1/12 px-8 py-8">
            <div class="border border-gray-300 h-0 lg:h-full w-full lg:w-0" />
          </div>
          <Form
            class="lg:w-2/12"
            :form="$v.formAnonymous"
            :form-sent="formAnonymous.sent"
            :submit-name="$t('anonymous')"
            @submit.prevent="anonymous"
          >
            <h2>
              {{ $t('anonymousTitle') }}
            </h2>
            <p>
              {{ $t('anonymousDescription') }}
            </p>
          </Form>
          <p class="opacity-50 text-center text-sm w-full">
            {{ $t('disclaimer') }}
          </p>
        </div>
      </div>
      <div v-else class="info">
        {{ $t('datalessEvent') }}
      </div>
    </div>
  </div>
</template>

<script>
import { required } from 'vuelidate/lib/validators'

import EVENT_BY_NAME from '~/gql/query/event/eventByName.gql'

export default {
  name: 'IndexPage',
  apollo: {
    event() {
      return {
        query: EVENT_BY_NAME,
        variables: {
          eventName: this.$route.params.eventName,
        },
        update: (data) => this.$util.getNested(data, 'eventByName'),
        error(error, _vm, _key, _type, _options) {
          this.graphqlError = error.message
        },
      }
    },
  },
  data() {
    return {
      form: {
        participationCode:
          this.$route.query.ic === undefined ? undefined : this.$route.query.ic,
        sent: false,
      },
      formAnonymous: {
        sent: false,
      },
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
    participationCodeModel: {
      get() {
        return this.$route.query.ic !== undefined
          ? this.$route.query.ic
          : this.$v.form.participationCode.$model
      },
      set(value) {
        this.$v.form.participationCode.$model = value
      },
    },
  },
  mounted() {
    if (this.$route.query.ic !== undefined) {
      this.$v.form.participationCode.$touch()
    }
  },
  methods: {
    anonymous() {
      this.$store.commit('setParticipationData', { role: 'watcher' })
      this.$router.push({
        append: true,
        path: 'instructions',
      })
    },
    async saveCode() {
      try {
        await this.$util.formPreSubmit(this)
      } catch (error) {
        return
      }

      this.$v.form.$reset()
      this.$store.commit('setParticipationData', {
        role: 'player',
        participationCode: this.form.participationCode,
      })
      this.$router.push({
        append: true,
        path: 'instructions',
      })
    },
  },
  validations() {
    return {
      form: {
        participationCode: {
          required,
          formatUuid: this.$util.VERIFICATION_FORMAT_UUID,
        },
      },
      formAnonymous: {},
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
  greeting: 'Schön, dass du da bist! 😊 Jetzt kann es losgehen.'
  participationCode: 'Teilnahmecode'
  participationCodeAutomatic: 'Der Teilnahmecode wurde automatisch für dich eingegeben.'
  participationCodeManual: 'Code selbst eingeben.'
  participate: 'Mitmachen'
  participateDescription: 'Die Standard-Wahl für alle eingeladenen Gäste. Volle Power ins Abenteuer! 🥳🚀'
  save: 'Zu meiner Übersichtsseite'
  disclaimer: 'Für die kommende Veranstaltung sind Coronaschutzmaßnahmen implementiert. Der Kontakt zu entsprechenden Behörden besteht.'
  title: 'Willkommen!'
</i18n>
