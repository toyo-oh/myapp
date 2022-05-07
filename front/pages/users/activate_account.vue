<template>
  <v-container>
    <div></div>
  </v-container>
</template>

<script>
export default {
  data() {
    return {
      message: "",
    }
  },
  created() {
    this.initPage()
  },
  methods: {
    initPage() {
      this.$axios
        .$post(`/api/account/activate_account`, {
          token: this.$route.query.token,
        })
        .then((res) => {
          if (res.code === "ok") {
            this.$toast.show(res.message)
            this.$router.push("/login")
          } else {
            this.$toast.error(res.message)
            this.$router.push({ path: "/users/new" })
          }
        })
    },
  },
}
</script>
