<template>
  <div>
    <v-alert v-model="alertLoginError" type="error" close-text="Close Alert" dismissible>
      {{ errorMessage }}
    </v-alert>
    <v-form ref="form" v-model="valid">
      <v-container>
        <v-card width="500px" class="mx-auto mt-5">
          <div class="px-3 px-md-10 py-8">
            <h2 class="text-center brown--text text--darken-3">Log In</h2>
            <div class="d-flex align-center my-1">
              <v-divider></v-divider>
              <br />
            </div>
            <v-text-field
              v-model="login.email"
              outlined
              dense
              color="brown lighten-3"
              type="text"
              label="email"
              :rules="emailRules"
              required></v-text-field>
            <v-text-field
              v-model="login.password"
              outlined
              dense
              color="brown lighten-3"
              type="password"
              label="Password"
              :rules="pwdRules"
              required></v-text-field>
            <v-btn block large dark class="mr-4" color="brown lighten-1" @click="userLogin"
              >Log In</v-btn
            >
            <div class="text-body-2 text-center my-3">
              Forgot Your Password?
              <router-link to="/users/forget_password" class="brown--text">Reset It</router-link>
            </div>
          </div>
        </v-card>
      </v-container>
    </v-form>
  </div>
</template>

<script>
export default {
  middleware({ store, redirect }) {
    if (store.$auth.loggedIn) {
      redirect("/home")
    }
  },
  data() {
    return {
      alertLoginError: false,
      errorMessage: "",
      valid: true,
      login: {
        email: "",
        password: "",
      },
      emailRules: [(v) => !!v || "Email is required"],
      pwdRules: [(v) => !!v || "Password is required"],
    }
  },
  methods: {
    userLogin() {
      if (this.$refs.form.validate()) {
        this.$auth.loginWith("local", { data: this.login }).then((res) => {
          if (res.data.code === "error") {
            this.$toast.error(res.data.message)
          } else {
            this.$toast.show(res.data.message)
            this.$axios.$get(`api/cart/find_cart/${this.$auth.user.hashid}`).then((res) => {
              this.$store.commit("load_products", res.productList)
            })
          }
        })
      } else {
        this.alertLoginError = true
        this.errorMessage = "Invalid item in the form"
      }
    },
  },
}
</script>
