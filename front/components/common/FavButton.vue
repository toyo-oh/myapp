<template>
  <button text icon @click="togglefav">
    <v-icon v-if="favComp" class="ma-2" color="red lighten-2">mdi-heart</v-icon>
    <v-icon v-if="!favComp" class="ma-2">mdi-heart-outline</v-icon>
  </button>
</template>

<script>
export default {
  name: "FavButton",
  props: {
    isFav: { type: Boolean, default: false },
    phashid: { type: String, default: "" },
  },
  data: function () {
    return {
      favComp: this.isFav,
    }
  },
  methods: {
    togglefav: function () {
      if (this.$auth.loggedIn) {
        if (this.favComp) {
          // cancel
          this.$axios
            .post(`api/products/${this.phashid}/cancel_favourite`, {
              user_id: this.$auth.user.hashid,
              product_id: this.phashid,
            })
            .then((res) => {
              if (res.data.code === "error") {
                this.$toast.error(res.data.message)
              } else {
                this.favComp = !this.favComp
                this.$toast.show(res.data.message)
              }
            })
        } else {
          // add
          this.$axios
            .post(`api/products/${this.phashid}/add_favourite`, {
              user_id: this.$auth.user.hashid,
              product_id: this.phashid,
            })
            .then((res) => {
              if (res.data.code === "error") {
                this.$toast.error(res.data.message)
              } else {
                this.favComp = !this.favComp
                this.$toast.show(res.data.message)
              }
            })
        }
      } else {
        this.$router.push(`/login`)
        this.$toast.error("please login!")
      }
    },
  },
}
</script>
