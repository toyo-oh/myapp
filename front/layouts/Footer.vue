<template>
  <v-footer color="brown lighten-5" padless>
    <v-row justify="center" no-gutters>
      <v-btn v-for="link in links" :key="link" color="brown" text rounded class="my-2">
        {{ link }}
      </v-btn>
      <v-col class="brown lighten-5 py-4 text-center brown--text" cols="12">
        <v-avatar size="60" tile class="mb-0 mr-2">
          <img src="@/assets/images/logo.png" alt="" />
        </v-avatar>
        &copy; {{ new Date().getFullYear() }} <strong></strong>
      </v-col>
    </v-row>
  </v-footer>
</template>
<script>
export default {
  name: "Footer",
  data: () => ({
    links: [
      'Returns & Funds',
      'Terms & Conditions',
      'Services',
      'Privacy Policy',
      'Help Center',
      'Contact Us',
    ]
  }),
};
</script>
<style lang="scss">
</style>



