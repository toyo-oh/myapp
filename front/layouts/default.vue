<template>
  <v-app dark>
    <AppBar />
    <v-main>
      <v-container>
        <nuxt />
      </v-container>
    </v-main>
    <Footer />
  </v-app>
</template>

<script>
export default {
  components: {
    AppBar: () => import('./AppBar'),
    Footer: () => import('./Footer'),
  }
}
</script>
