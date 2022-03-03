<template>
  <div>
    <v-alert v-model="alertLoginError" type="error" close-text="Close Alert" dismissible>
      {{error_message}}
    </v-alert>
    <v-form ref="form" v-model="valid">
      <v-container>
        <v-card width="500px" class="mx-auto mt-5">
          <div class="px-3 px-md-10 py-8 ">
            <h2 class="text-center brown--text text--darken-3">Log In</h2>
            <div class="d-flex align-center my-1">
              <v-divider></v-divider>
              <br />
            </div>
            <!-- <h5 class="grey--text text--darken-3 text-sm mb-9 text-center">Log in with email & password</h5> -->
            <v-text-field outlined dense color="brown lighten-3" v-model="login.email" type="text" label="email" :rules="emailRules" required></v-text-field>
            <v-text-field outlined dense color="brown lighten-3" v-model="login.password" type="password" label="Password" :rules="pwdRules" required></v-text-field>
            <v-btn block large dark class="mr-4" color="brown lighten-1" @click="userLogin">Log In</v-btn>
            <div class="text-body-2 text-center my-3">Forgot Your Password? <router-link to="/login">Reset It</router-link>
            </div>
          </div>
        </v-card>
      </v-container>
    </v-form>
  </div>
</template> 

<script>
export default ({
  // auth: false,
  middleware ({ store, redirect }) {
    if (store.$auth.loggedIn) {
      redirect('/');
    }
  },
  data () {
    return {
      alertLoginError: false,
      error_message: '',
      valid: true,
      login: {
        email: '',
        password: ''
      },
      emailRules: [v => !!v || 'Email is required',],
      pwdRules: [v => !!v || 'Password is required',]
    }
  },
  methods: {
    userLogin () {
      if (this.$refs.form.validate()) {
        this.$auth.loginWith('local', { data: this.login }).then((res) => {
          if (res && res.status === 200) {
            this.$axios.$get(`api/cart/find_cart/${this.$auth.user.id}`).then((res) => {
              this.$store.commit('load_products', res.productList);
            });
          }
        }).catch((err) => {
          if (err.response && err.response.status === 401) {
            this.alertLoginError = true;
            this.error_message = 'Account or password is incorrect';
          }
        });
      } else {
        this.alertLoginError = true;
        this.error_message = 'Invalid item in the form';
      }
    }
  }
})
</script>
