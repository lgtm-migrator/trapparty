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
          class="card my-8 flex flex-col items-center lg:flex-row lg:flex-wrap"
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
              :error="$v.form.invitationCode.$error"
              label-for="input-participation-code-trapparty"
              :title="$t('invitationCode')"
            >
              <!--
                The id's suffix `-trapparty` makes browser suggest inputs just
                for this service.
              -->
              <input
                id="input-participation-code-trapparty"
                v-model.trim="invitationCodeModel"
                class="form-input"
                :disabled="$route.query.ic"
                type="text"
                placeholder="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
              />
              <template slot="inputInfo">
                <div v-if="$route.query.ic">
                  {{ $t('invitationCodeAutomatic') }}
                  <AppLink
                    :to="
                      localePath({
                        query: null,
                      })
                    "
                  >
                    {{ $t('invitationCodeManual') }}
                  </AppLink>
                </div>
              </template>
              <template slot="inputError">
                <FormInputError
                  :form-input="$v.form.invitationCode"
                  validation-property="required"
                >
                  {{ $t('globalValidationRequired') }}
                </FormInputError>
                <FormInputError
                  :form-input="$v.form.invitationCode"
                  validation-property="formatUuid"
                >
                  {{ $t('globalValidationFormatIncorrect') }}
                </FormInputError>
              </template>
            </FormInput>
          </Form>
          <div class="self-stretch px-8 py-8 lg:w-1/12">
            <div class="h-0 w-full border border-gray-300 lg:h-full lg:w-0" />
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
          <p class="w-full text-center text-sm opacity-50">
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
          eventName: '2021',
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
        invitationCode:
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
    invitationCodeModel: {
      get() {
        return this.$route.query.ic !== undefined
          ? this.$route.query.ic
          : this.$v.form.invitationCode.$model
      },
      set(value) {
        this.$v.form.invitationCode.$model = value
      },
    },
  },
  mounted() {
    if (this.$route.query.ic !== undefined) {
      this.$v.form.invitationCode.$touch()
    }
  },
  methods: {
    anonymous() {
      this.$store.commit('setParticipationData', { role: 'watcher' })
      this.$router.push({
        append: true,
        path: 'dashboard',
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
        invitationCode: this.form.invitationCode,
      })
      this.$router.push({
        append: true,
        path: 'dashboard',
      })
    },
  },
  validations() {
    return {
      form: {
        invitationCode: {
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
  anonymous: 'Anonym teilnehmen'
  anonymousDescription: 'Du möchtest nur zuschauen?'
  anonymousTitle: '👻'
  datalessEvent: 'Aktuell sind keine Daten für eine kommende TrapParty vorhanden.'
  greeting: 'Schön, dass du da bist! 😊 Jetzt kann es losgehen.'
  invitationCode: 'Teilnahmecode'
  invitationCodeAutomatic: 'Der Teilnahmecode wurde automatisch für dich eingegeben.'
  invitationCodeManual: 'Code selbst eingeben.'
  participate: 'Mitmachen'
  participateDescription: 'Die Standard-Wahl für alle eingeladenen Gäste. Volle Power ins Abenteuer! 🥳🚀'
  save: 'Zu meiner Übersichtsseite'
  disclaimer: 'Für die kommende Veranstaltung sind Coronaschutzmaßnahmen implementiert. Der Kontakt zu entsprechenden Behörden besteht.'
  title: 'Willkommen!'
</i18n>
