<template>
  <v-form>
    <v-container>
      <v-card width="400px" class="mx-auto mt-5">
        <v-card-title>
          <h1 class="display-1">Sign In</h1>
        </v-card-title>
        <v-card-text>
          <v-text-field v-model="email" type="text" label="email" required></v-text-field>
          <v-text-field v-model="password" type="password" label="Password" required></v-text-field>
        </v-card-text>
        <v-card-actions>
          <v-btn class="mr-4" color="primary" @click="login">login</v-btn>
        </v-card-actions>
      </v-card>
    </v-container>
  </v-form>
</template> 

<script>
export default ({
  data () {
    return {
      email: '',
      password: '',
    }
  },
  methods: {
    login () {
      this.$axios.post('/api/users/login', {
        email: this.email,
        password: this.password,
      }).then((res) => {
        // this.$router.push(`${res.data.id}`)
      })
    }
  }
})
</script>
