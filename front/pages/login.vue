<template>
  <div>
    <v-alert v-model="alertLoginError" type="error" close-text="Close Alert" dismissible>
      LOGIN INPUT ERROR.
    </v-alert>
    <v-form ref="form" v-model="valid">
      <v-container>
        <v-card width="500px" class="mx-auto mt-5">
          <v-card-title>
            <h1 class="display-1">Log In</h1>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text>
            <v-text-field outlined v-model="login.email" type="text" label="email" :rules="emailRules" required></v-text-field>
            <v-text-field outlined v-model="login.password" type="password" label="Password" :rules="pwdRules" required></v-text-field>
          </v-card-text>
          <v-card-actions>
            <v-btn block large elevation="5" class="mr-4" color="primary" @click="userLogin">login</v-btn>
          </v-card-actions>
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
          if (res.data != null) {
            // update cart item
            this.$axios.$get(`api/cart/find_cart/${this.$auth.user.id}`).then((res) => {
              this.$store.commit('load_products', res.productList);
            });
          } else {
            // TODO
          }
        });
      } else {
        this.alertLoginError = true;
      }
    }
  }
})
</script>
