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
            <h2 class="mb-0">Edit Email</h2>
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
            <v-text-field outlined　dense color="brown lighten-3" v-model="currentEmail" label="Current Email" :rules="currentEmailRules" type="text"></v-text-field>
            <v-text-field outlined　dense color="brown lighten-3" v-model="password" label="Password" type="password" :rules="passwordRules"></v-text-field>
            <v-text-field outlined　dense color="brown lighten-3" v-model="newEmail" label="New Email" type="text" :rules="newEmailRules"></v-text-field>
            <v-text-field outlined　dense color="brown lighten-3" v-model="confirmEmail" label="Confirm Email" type="text" :rules="emailConfirmRules"></v-text-field>
            <v-btn dark class="mr-4" color="brown lighten-1" @click="updateEmail">Save Changes</v-btn>
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
      currentEmail: '',
      password: '',
      newEmail: '',
      confirmEmail: '',
      currentEmailRules: [
        v => !!v || 'Current Email is required',
      ],
      passwordRules: [
        v => !!v || 'Password is required',
      ],
      newEmailRules: [
        v => !!v || 'Email is required',
        v => /.+@.+\..+/.test(v) || 'Email must be valid',
      ],
      emailConfirmRules: [
        v => !!v || 'Confirm Email is required',
        v => /.+@.+\..+/.test(v) || 'Confirm Email must be valid',
        v => v === this.newEmail || 'The email confirmation does not match.',
      ],
    }
  },
  methods: {
    updateEmail () {
      if (this.$auth.loggedIn) {
        if (this.$refs.form.validate()) {
          this.$axios.post(`/api/users/${this.$auth.user.id}/update_email`, {
            current_email: this.currentEmail,
            password: this.password,
            newEmail: this.newEmail,
            confirmEmail: this.confirmEmail,
            id: this.$auth.user.id
          }).then((res) => {
            this.$auth.loginWith('local', { data: { email: res.data.email, password: this.password } })
              .then(() => {
                this.$router.push(`/users/${this.$auth.user.id}`);
                this.$toast.show('Update Email successfully!');
              });
          }).catch((err) => {
            if (err.response && err.response.status === 401) {
              this.$toast.error('Unauthorized!');
            }
          })
        } else {
          this.alertFormError = true;
        }
      } else {
        this.$router.push(`/login`)
      }
    },
    rtnToProfile () {
      this.$router.push(`/users/${this.$auth.user.id}`)
    }
  }
}
</script>