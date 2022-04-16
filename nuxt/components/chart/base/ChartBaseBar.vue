<template>
  <Bar :chart-data="data" :chart-options="options" :height="height" />
</template>

<script lang="ts">
import {
  BarController,
  BarElement,
  CategoryScale,
  Chart,
  ChartData,
  ChartOptions,
  LinearScale,
  Title,
  Tooltip,
} from 'chart.js'
import merge from 'lodash.merge'
import { Bar } from 'vue-chartjs/legacy'

import { defineComponent, PropType } from '#app'

Chart.register(
  BarController,
  BarElement,
  CategoryScale,
  LinearScale,
  Title,
  Tooltip
)

export default defineComponent({
  components: {
    Bar,
  },
  props: {
    data: {
      type: Object as PropType<ChartData<'bar'>>,
      default: undefined,
    },
    height: {
      type: Number,
      default: 150, // 400
    },
    horizontal: {
      type: Boolean,
      default: true,
    },
    optionsAdditional: {
      type: Object as PropType<ChartOptions<'bar'>>,
      default: undefined,
    },
  },
  computed: {
    options(): ChartOptions<'bar'> {
      const optionsDefault: ChartOptions<'bar'> = {
        indexAxis: this.$props.horizontal ? 'y' : 'x',
        plugins: {
          legend: {
            display: false,
          },
          title: {
            display: true,
            font: {
              size: 24,
            },
          },
        },
        scales: {
          x: {
            grid: {
              display: false,
            },
            stacked: true,
            ticks: {
              font: {
                size: 17,
              },
            },
          },
          y: {
            grid: {
              borderColor: '#666',
              color: '#666',
            },
            stacked: true,
            ticks: {
              font: {
                size: 17,
              },
            },
          },
        },
      }
      return merge(optionsDefault, this.optionsAdditional)
    },
  },
})
</script>
