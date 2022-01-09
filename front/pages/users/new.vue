<template>
  <v-form>
    <v-container>
      <v-card width="500px" class="mx-auto mt-5">
        <v-card-title>
          <h1 class="display-1">Sign Up</h1>
        </v-card-title>
        <v-divider></v-divider>
        <v-card-text>
          <!-- <v-row justify="center"> -->
          <!-- <v-col cols="12" md="6"> -->
          <v-text-field outlined　v-model="name" type="text" label="Name" required></v-text-field>
          <v-text-field outlined　v-model="password" type="password" label="Password" required></v-text-field>
          <v-text-field outlined　v-model="password_confirmation" type="password" label="password_confirmation" required></v-text-field>
          <v-text-field outlined　v-model="email" type="text" label="Email" required></v-text-field>
          <v-switch v-model="is_admin" class="ma-4" label="Administrator"></v-switch>
          <!-- </v-col> -->
          <!-- </v-row> -->
        </v-card-text>
        <v-card-actions>
          <v-btn block large elevation="5" class="mr-4" color="primary" @click="createUser">submit</v-btn>
        </v-card-actions>
      </v-card>
    </v-container>
  </v-form>
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
      name: '',
      password: '',
      password_confirmation: '',
      email: '',
      is_admin: false
    }
  },
  methods: {
    createUser () {
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
    }
  }
})
</script>
