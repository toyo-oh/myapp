<template>
  <div>
    <v-alert v-model="alertSignUpError" type="error" close-text="Close Alert" dismissible>
      There are Input Errors in the form.
    </v-alert>
    <v-form ref="form" v-model="valid">
      <v-container>
        <v-card width="500px" class="mx-auto mt-5">
          <div class="px-3 px-md-10 py-8">
            <h2 class="text-center brown--text text--darken-3">Sign Up</h2>
            <div class="d-flex align-center my-1">
              <v-divider></v-divider>
              <br />
            </div>
            <!-- <h5 class="grey--text text--darken-3 text-sm mb-9 text-center">Please fill all forms to continued</h5> -->
            <v-text-field
              v-model="name"
              outlined
              dense
              color="brown lighten-3"
              type="text"
              label="Name"
              :rules="nameRules"
              required></v-text-field>
            <v-text-field
              v-model="password"
              outlined
              dense
              color="brown lighten-3"
              type="password"
              label="Password"
              :rules="pwdRules"
              required></v-text-field>
            <v-text-field
              v-model="passwordConfirmation"
              outlined
              dense
              color="brown lighten-3"
              type="password"
              label="Password Confirmation"
              :rules="pwdConfirmRules"
              required></v-text-field>
            <v-text-field
              v-model="email"
              outlined
              dense
              color="brown lighten-3"
              type="text"
              label="Email"
              :rules="emailRules"
              required></v-text-field>
            <!-- <v-switch v-model="is_admin" class="ma-4" label="Administrator"></v-switch> -->
            <v-checkbox
              v-model="agree"
              color="brown lighten-1"
              :rules="agreeRules"
              label="By signing up, you agree to terms and conditions?"
              required></v-checkbox>
            <v-btn block large dark class="mr-4" color="brown lighten-1" @click="createUser"
              >SUBMIT</v-btn
            >
            <div class="text-body-2 text-center my-3">
              Already Have Account?
              <router-link to="/login">Log In</router-link>
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
      redirect("/")
    }
  },
  data() {
    return {
      valid: true,
      alertSignUpError: false,
      name: "",
      password: "",
      passwordConfirmation: "",
      email: "",
      isAdmin: false,
      agree: "",
      nameRules: [
        (v) => !!v || "Name is required",
        (v) => (v && v.length <= 10) || "Name must be less than 10 characters",
      ],
      emailRules: [
        (v) => !!v || "Email is required",
        (v) => /.+@.+\..+/.test(v) || "Email must be valid",
      ],
      pwdRules: [
        (v) => !!v || "Password is required",
        (v) =>
          (v && v.length >= 6 && v.length <= 20) ||
          "Password must be more than 6 and less than 20 characters",
      ],
      pwdConfirmRules: [
        (v) => !!v || "Confirm Password is required",
        (v) =>
          (v && v.length >= 6 && v.length <= 20) ||
          "Confirm Password must be more than 6 and less than 20 characters",
        (v) => v === this.password || "The password confirmation does not match.",
      ],
      agreeRules: [(v) => !!v || "You must agree to continue!"],
    }
  },
  methods: {
    createUser() {
      if (this.$refs.form.validate()) {
        this.$axios
          .post("/api/users", {
            name: this.name,
            password: this.password,
            password_confirmation: this.passwordConfirmation,
            email: this.email,
            isAdmin: this.isAdmin,
          })
          .then((res) => {
            if (res.data.code === "error") {
              this.$toast.error(res.data.message)
            } else {
              this.$toast.show(res.data.message)
              this.$router.push(`/home`)
            }
          })
      } else {
        this.alertSignUpError = true
      }
    },
  },
}
</script>
