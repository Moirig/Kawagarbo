<template>
  <div>
    <h1>{{ msg }}</h1>
    <button @click="test">invoke</button>
    <button @click="request">request {{ interceptorOn ? ' with interceptor' : '' }} </button>
  </div>
</template>

<script>
import { kw } from "@/utils/kawagarbo.js";

export default {
  name: "Demo",
  data() {
    return {
      msg: "Kawagarbo",
      interceptorOn: false
    };
  },
  methods: {
    test() {
      kw.subscribe()
      kw.invoke({
        complete: function (res) {
          alert(JSON.stringify(res));
        },
      });
      // this.$router.push({path: '/', query: { plan: 'private' }})
      // console.log(this.$route)
    },
    request() {
      let xhr = new XMLHttpRequest();
      xhr.open("post", "https://httpbin.org/post");
      xhr.onload = (oEvent) => {
        alert(xhr.response);

        this.interceptorOn = !this.interceptorOn
        kw.testInterceptor({ enable: this.interceptorOn })
      };
      xhr.send({ a: 1, b: 'c'});
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
