<template>
  <div>
    <v-alert v-model="alertSignUpError" type="error" close-text="Close Alert" dismissible>
      FORM INPUT ERROR.
    </v-alert>
    <v-form ref="form" v-model="valid">
      <v-container>
        <v-card width="500px" class="mx-auto mt-5">
          <v-card-title>
            <h1 class="display-1">Sign Up</h1>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <v-text-field outlined　v-model="name" type="text" label="Name" :rules="nameRules" required></v-text-field>
            <v-text-field outlined　v-model="password" type="password" label="Password" :rules="pwdRules" required></v-text-field>
            <v-text-field outlined　v-model="password_confirmation" type="password" label="password_confirmation" :rules="pwdConfirmRules" required></v-text-field>
            <v-text-field outlined　v-model="email" type="text" label="Email" :rules="emailRules" required></v-text-field>
            <v-switch v-model="is_admin" class="ma-4" label="Administrator"></v-switch>
          </v-card-text>
          <v-card-actions>
            <v-btn block large elevation="5" class="mr-4" color="primary" @click="createUser">submit</v-btn>
          </v-card-actions>
        </v-card>
      </v-container>
    </v-form>
  </div>
</template> 

<script>
export default ({
  middleware ({ store, redirect }) {
    if (store.$auth.loggedIn) {
      redirect('/');
    }
  },
  data () {
    return {
      valid: true,
      alertSignUpError: false,
      name: '',
      password: '',
      password_confirmation: '',
      email: '',
      is_admin: false,
      nameRules: [
        v => !!v || 'Name is required',
        v => (v && v.length <= 10) || 'Name must be less than 10 characters',
      ],
      emailRules: [
        v => !!v || 'Email is required',
        v => /.+@.+\..+/.test(v) || 'Email must be valid',
      ],
      pwdRules: [
        v => !!v || 'Password is required',
        v => (v && v.length >= 6 && v.length <= 20) || 'Password must be more than 6 and less than 20 characters',
      ],
      pwdConfirmRules: [
        v => !!v || 'Confirm Password is required',
        v => (v && v.length >= 6 && v.length <= 20) || 'Confirm Password must be more than 6 and less than 20 characters',
        v => v === this.password || 'The password confirmation does not match.',
      ]
    }
  },
  methods: {
    createUser () {
      if (this.$refs.form.validate()) {
        this.$axios.post('/api/users', {
          name: this.name,
          password: this.password,
          password_confirmation: this.password_confirmation,
          email: this.email,
          is_admin: this.is_admin
        }).then((res) => {
          // login after signed up
          var login = {};
          login.email = this.email;
          login.password = this.password;
          this.$auth.loginWith('local', { data: login });
        })
      } else {
        this.alertSignUpError = true;
      }
    }
  }
})
</script>
