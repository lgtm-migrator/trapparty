<template>
  <div class="text-3xl lg:text-8xl text-justify">
    <div>
      <span class="text-gray-500">Du bist</span> Jonas Thelemann<span
        class="text-gray-500"
        >, du hast</span
      >
      0 Punkte<span class="text-gray-500">.</span>
    </div>
    <div v-if="randomFactGiver">
      <span class="text-gray-500">Vor dir steht</span> {{ randomFactGiver
      }}<span class="text-gray-500">. Welcher</span>
      random fact
      <span class="text-gray-500">ist wahr? 🤔</span>
      <div
        class="flex flex-col lg:flex-row gap-4 lg:gap-16 justify-evenly m-4 lg:m-16"
      >
        <Button class="px-4 lg:px-16 py-8">Fact A</Button>
        <Button class="px-4 lg:px-16 py-8">Fact B</Button>
      </div>
    </div>
    <div v-else>
      <span class="text-gray-500">Aktuell gibt es</span> keine Abstimmung<span
        class="text-gray-500"
        >.</span
      >
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from '#app'

export default defineComponent({
  name: 'IndexPage',
  data() {
    return {
      randomFactGiver: 'Jonas Thelemann',
    }
  },
})
</script>
