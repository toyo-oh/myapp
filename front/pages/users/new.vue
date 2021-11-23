<template>
  <v-form>
    <v-container>
      <v-card width="400px" class="mx-auto mt-5">
        <v-card-title>
          <h1 class="display-1">Sign Up</h1>
        </v-card-title>
        <v-card-text>
          <!-- <v-row justify="center"> -->
          <!-- <v-col cols="12" md="6"> -->
          <v-text-field v-model="name" type="text" label="Name" required></v-text-field>
          <v-text-field v-model="password" type="password" label="Password" required></v-text-field>
          <v-text-field v-model="password_confirmation" type="password" label="password_confirmation" required></v-text-field>
          <v-text-field v-model="email" type="text" label="Email" required></v-text-field>
          <v-switch v-model="is_admin" class="ma-4" label="Administrator"></v-switch>
          <!-- </v-col> -->
          <!-- </v-row> -->
        </v-card-text>
        <v-card-actions>
          <v-btn class="mr-4" color="primary" @click="createUser">submit</v-btn>
          <v-btn @click="clear">clear</v-btn>
        </v-card-actions>
      </v-card>
    </v-container>
  </v-form>
</template> 

<script>
export default ({
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
    clear () {
      this.name = '',
        this.password = '',
        this.password_confirmation = '',
        this.email = '',
        this.is_admin = false
    },
    createUser () {
      this.$axios.post('/api/users', {
        name: this.name,
        password: this.password,
        password_confirmation: this.password_confirmation,
        email: this.email,
        is_admin: this.is_admin
      }).then((res) => {
        this.$router.push(`${res.data.id}`)
      })
    }
  }
})
</script>
