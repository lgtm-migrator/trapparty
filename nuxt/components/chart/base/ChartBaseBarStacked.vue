<script>
import merge from 'lodash.merge'
import { Bar } from 'vue-chartjs'

export default {
  extends: Bar,
  props: {
    data: {
      type: Object,
      default: undefined,
    },
    height: {
      type: Number,
      default: 150,
    },
    optionsAdditional: {
      type: Object,
      default: undefined,
    },
    title: {
      type: String,
      default: undefined,
    },
  },
  data() {
    return {
      optionsDefault: {
        responsive: true,
        legend: {
          display: false,
        },
        title: {
          display: true,
          fontSize: 24,
        },
        scales: {
          xAxes: [
            {
              gridLines: {
                display: false,
              },
              stacked: true,
              ticks: {
                fontSize: '17',
              },
            },
          ],
          yAxes: [
            {
              gridLines: {
                color: '#666',
              },
              stacked: true,
              ticks: {
                fontSize: '17',
              },
            },
          ],
        },
      },
    }
  },
  computed: {
    options() {
      return merge(this.optionsDefault, this.optionsAdditional)
    },
  },
  mounted() {
    this.renderChart(this.data, this.options)
  },
}
</script>
