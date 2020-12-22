<template>
  <section>
    <h1>
      {{ $t('title') }}
    </h1>
    <ChartTeamScore :event="event" />
    <ChartTeamDonationAmount :event="event" />
    <ChartTeamScoreTotal :event="event" />
  </section>
</template>

<script>
export default {
  props: {
    event: {
      type: Object,
      default: undefined,
    },
  },
}
</script>

<i18n lang="yml">
de:
  title: 'Teamwertung'
</i18n>
