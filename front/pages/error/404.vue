<template>
  <v-app dark>
    <v-row>
      <v-col cols="12">
        <div class="d-flex justify-center align-center">
          <img src="@/assets/images/error/404.jpg" width="600" height="400" />
          <h1 class="brown--text text--darken-4">The page is Not Found</h1>
        </div>
      </v-col>
    </v-row>
  </v-app>
</template>

<script>
export default {
  // layout: 'empty',
  data() {
    return {
      pageNotFound: "404 Not Found",
    }
  },
  head() {
    const title = this.pageNotFound
    return {
      title,
    }
  },
}
</script>
