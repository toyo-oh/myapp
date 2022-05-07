<template>
  <v-app dark>
    <v-row>
      <v-col cols="12">
        <div class="d-flex justify-center align-center">
          <img src="@/assets/images/error/500.jpg" width="1000" height="600" />
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
      otherError: "An error occurred",
    }
  },
  head() {
    const title = this.otherError
    return {
      title,
    }
  },
}
</script>

<style scoped>
h1 {
  font-size: 20px;
}
</style>
