<template>
  <v-container>
    <div>
      <v-alert v-model="alertFormError" type="error" close-text="Close Alert" dismissible>
        There are Input Errors in the form.
      </v-alert>
      <v-row justify="center">
        <v-col cols="3">
          <div class="d-flex align-center">
            <v-avatar tile size="25" class="me-3">
              <v-icon> mdi-account</v-icon>
            </v-avatar>
            <h2 class="mb-0">Reset Password</h2>
          </div>
        </v-col>
      </v-row>
      <v-row justify="center">
        <v-col cols="12" md="6">
          <v-form ref="form" v-model="valid">
            <v-text-field
              v-model="newPassword"
              outlined
              dense
              color="brown lighten-3"
              label="New Password"
              type="password"
              :rules="newPasswordRules"></v-text-field>
            <v-text-field
              v-model="confirmPassword"
              outlined
              dense
              color="brown lighten-3"
              label="Confirm Password"
              type="password"
              :rules="confirmPasswordRules"></v-text-field>
            <v-btn dark class="mr-4" color="brown lighten-1" @click="resetPassword"
              >Reset Password</v-btn
            >
          </v-form>
        </v-col>
      </v-row>
    </div>
  </v-container>
</template>

<script>
export default {
  data() {
    return {
      valid: true,
      alertFormError: false,
      newPassword: "",
      confirmPassword: "",
      newPasswordRules: [
        (v) => !!v || "Password is required",
        (v) =>
          (v && v.length >= 6 && v.length <= 20) ||
          "Password must be more than 6 and less than 20 characters",
      ],
      confirmPasswordRules: [
        (v) => !!v || "Confirm Password is required",
        (v) =>
          (v && v.length >= 6 && v.length <= 20) ||
          "Confirm Password must be more than 6 and less than 20 characters",
        (v) => v === this.newPassword || "The password confirmation does not match.",
      ],
    }
  },
  methods: {
    resetPassword() {
      if (this.$refs.form.validate()) {
        this.$axios
          .post(`/api/password/reset_password`, {
            token: this.$route.query.token,
            new_password: this.newPassword,
            confirm_password: this.confirmPassword,
          })
          .then(() => {
            this.$router.push("/login")
            this.$toast.show("Your password has been successfully reset! Please login in.")
          })
          .catch((err) => {
            if (err.response && err.response.status != 200) {
              this.$router.push("/login")
              this.$toast.error("Your token has been expired, please try again.")
            }
          })
      } else {
        this.alertFormError = true
      }
    },
  },
}
</script>
