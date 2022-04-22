<template>
  <v-footer color="brown lighten-5" padless>
    <v-row justify="center" no-gutters>
      <v-btn v-for="link in links" :key="link.index" color="brown" text rounded class="my-2" @click="link.action">
        {{ link.text }}
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
  data () {
    return {
      links: [
        { text: 'About Us', action: this.toAboutUs },
        { text: 'Terms Of Use', action: this.toTermOfUse },
        { text: 'Privacy Policy', action: this.toPrivacyPolicy },
        { text: 'Customer Services', action: this.toCustomerServices },
        { text: 'Contact Us', action: this.toContactUs }
      ]
    }
  },
  methods: {
    toAboutUs () {
      this.$router.push(`/footer/about_us`)
    },
    toTermOfUse () {
      this.$router.push(`/footer/term_of_use`)
    },
    toPrivacyPolicy () {
      this.$router.push(`/footer/privacy_policy`)
    },
    toCustomerServices () {
      this.$router.push(`/footer/customer_services`)
    },
    toContactUs () {
      this.$router.push(`/footer/contact_us`)
    }
  }
}
</script>
<style lang="scss">
</style>