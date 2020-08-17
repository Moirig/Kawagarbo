<template>
  <div>
    <h1>{{ msg }}</h1>
    <button @click="test">invoke</button>
  </div>
</template>

<script>
import { kw } from '@/utils/kawagarbo.js'

export default {
  name: 'Demo',
  data () {
    return {
      msg: 'Kawagarbo'
    }
  },
  methods: {
    test () {
      kw.invoke({
        complete: function (res) {
          // alert(JSON.stringify(res))
        }
      })
      this.$router.push({path: '/', query: { plan: 'private' }})
      // console.log(this.$route)
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
