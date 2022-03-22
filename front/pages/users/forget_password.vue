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
            <h2 class="mb-0">Input your Email</h2>
          </div>
        </v-col>
      </v-row>
      <v-row justify="center">
        <v-col cols="12" md="6">
          <v-form ref="form" v-model="valid">
            <v-text-field outlined dense color="brown lighten-3" v-model="email" label="Email" :rules="emailRules" type="text"></v-text-field>
            <v-btn dark class="mr-4" color="brown lighten-1" @click="sendEmail">Send Email</v-btn>
          </v-form>
        </v-col>
      </v-row>
    </div>
  </v-container>
</template>

<script>
export default {
  data () {
    return {
      valid: true,
      alertFormError: false,
      email: '',
      emailRules: [
        v => !!v || 'Current Email is required'
      ]
    }
  },
  methods: {
    sendEmail () {
      if (this.$refs.form.validate()) {
        this.$axios.post(`/api/password/forget`, {
          email: this.email,
        }).then(() => {
          this.$router.push('/login');
          this.$toast.show('Reset mail has been send successfully!');
        })
      } else {
        this.alertFormError = true;
      }
    }
  }
}
</script>