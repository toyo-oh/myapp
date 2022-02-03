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
            <h2 class="mb-0">Edit Password</h2>
          </div>
        </v-col>
        <v-col cols="3">
          <v-btn outlined color="brown lighten-1" class="text-capitalize ml-16" @click="rtnToProfile">
            Back To My Profile
          </v-btn>
        </v-col>
      </v-row>
      <v-row justify="center">
        <v-col cols="12" md="6">
          <v-form ref="form" v-model="valid">
            <v-text-field outlined　dense color="brown lighten-3" v-model="email" label="Email" :rules="emailRules" type="text"></v-text-field>
            <v-text-field outlined　dense color="brown lighten-3" v-model="current_password" label="Current Password" type="password" :rules="currentPasswordRules"></v-text-field>
            <v-text-field outlined　dense color="brown lighten-3" v-model="new_password" label="New Password" type="password" :rules="newPasswordRules"></v-text-field>
            <v-text-field outlined　dense color="brown lighten-3" v-model="confirm_password" label="Confirm Password" type="password" :rules="confirmPasswordRules"></v-text-field>
            <v-btn dark class="mr-4" color="brown lighten-1" @click="updatePassword">Save Changes</v-btn>
          </v-form>
        </v-col>
      </v-row>
    </div>
  </v-container>
</template>

<script>
export default {
  middleware: 'auth',
  data () {
    return {
      valid: true,
      alertFormError: false,
      email: '',
      current_password: '',
      new_password: '',
      confirm_password: '',
      emailRules: [
        v => !!v || 'Current Email is required',
      ],
      currentPasswordRules: [
        v => !!v || 'Password is required',
      ],
      newPasswordRules: [
        v => !!v || 'Password is required',
        v => (v && v.length >= 6 && v.length <= 20) || 'Password must be more than 6 and less than 20 characters',
      ],
      confirmPasswordRules: [
        v => !!v || 'Confirm Password is required',
        v => (v && v.length >= 6 && v.length <= 20) || 'Confirm Password must be more than 6 and less than 20 characters',
        v => v === this.new_password || 'The password confirmation does not match.',
      ],
    }
  },
  methods: {
    updatePassword () {
      if (this.$auth.loggedIn) {
        if (this.$refs.form.validate()) {
          this.$axios.post(`/api/users/${this.$auth.user.id}/psw`, {
            email: this.email,
            current_password: this.current_password,
            new_password: this.new_password,
            confirm_password: this.confirm_password,
            id: this.$auth.user.id
          }).then((res) => {
            this.$auth.loginWith('local', { data: { email: res.data.email, password: this.new_password } })
              .then((res) => {
                this.$router.push(`/users/${this.$auth.user.id}`)
              });
          })
        } else {
          this.alertFormError = true;
        }
      }
    },
    rtnToProfile () {
      this.$router.push(`/users/${this.$auth.user.id}`)
    }
  }
}
</script>