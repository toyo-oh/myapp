<template>
  <v-app dark>
    <h1>
      {{pageNotFound}}
    </h1>
    <NuxtLink to="/">
      Home page
    </NuxtLink>
  </v-app>
</template>

<script>
export default {
  layout: 'empty',
  data () {
    return {
      pageNotFound: '404 Not Found',
      // otherError: 'An error occurred'
    }
  },
  head () {
    const title = this.pageNotFound
    return {
      title
    }
  }
}
</script>

<style scoped>
h1 {
  font-size: 20px;
}
</style>
