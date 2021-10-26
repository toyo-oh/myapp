<template>
  <v-form>
    <v-container>
      <v-card width="400px" class="mx-auto mt-5">
        <v-card-title>
          <h1 class="display-1">Sign In</h1>
        </v-card-title>
        <v-card-text>
          <v-text-field v-model="login.email" type="text" label="email" required></v-text-field>
          <v-text-field v-model="login.password" type="password" label="Password" required></v-text-field>
        </v-card-text>
        <v-card-actions>
          <v-btn class="mr-4" color="primary" @click="userLogin">login</v-btn>
        </v-card-actions>
      </v-card>
    </v-container>
  </v-form>
</template> 

<script>
export default ({
  // auth: false,
  // middleware ({ store, redirect }) {
  //   if (store.$auth.loggedIn) {
  //     redirect('/');
  //   }
  // },
  data () {
    return {
      login: {
        email: '',
        password: ''
      }
    }
  },
  methods: {
    async userLogin () {
      try {
        const response = await this.$auth.loginWith('local', { data: this.login });
        if (res.data != null) {
          this.$store.commit('user/login', res.data)
          localStorage.setItem('token', res.data.token)
          // this.$router.push(`${res.data.id}`)
        } else {
          // TODO
        }
      } catch (error) {

      }
    }

    // login () {
    //   this.$axios.post('/api/users/login', {
    //     email: this.email,
    //     password: this.password,
    //   }).then((res) => {
    //     //success TODO by return code
    //     if (res.data != null) {
    //       this.$store.commit('user/login', res.data)
    //       localStorage.setItem('token', res.data.token)
    //       this.$router.push(`${res.data.id}`)
    //     } else {
    //       // fail
    //     }
    //   })
    // }
  }
})
</script>
