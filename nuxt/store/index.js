// This file must exist for the i18n module too, as this file's existence enables the Vuex store.

export const state = () => ({
  participationData: null,
})

export const mutations = {
  setParticipationData(state, participationData) {
    state.participationData = participationData
  },
}
