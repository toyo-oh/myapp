<template>
  <v-form>
    <v-container>
      <v-card width="400px" class="mx-auto mt-5">
        <v-card-title>
          <h1 class="display-1">Edit Info</h1>
        </v-card-title>
        <v-card-text>
          <v-text-field v-model="name" type="text" label="Name"></v-text-field>
          <!-- <v-text-field v-model="password" type="password" label="Password"></v-text-field> -->
          <v-text-field v-model="email" type="text" label="Email"></v-text-field>
        </v-card-text>
        <v-card-actions>
          <v-btn class="mr-4" color="primary" @click="editUser">Edit Info</v-btn>
          <v-btn class="mr-4" color="primary" @click="editPassword">Edit Password</v-btn>
          <v-btn class="mr-4" color="primary" @click="editAddress">Edit Address</v-btn>
        </v-card-actions>
      </v-card>
    </v-container>
  </v-form>
</template> 


<script>
export default {
  data () {
    return {
      name: '',
      email: ''
    }
  },
  created () {
    this.loadUserData();
  },
  methods: {
    async loadUserData () {
      if (this.$auth.loggedIn) {
        const response = await this.$axios.$get(`/api/users/${this.$auth.user.id}`);
        this.name = response.data.name;
        this.email = response.data.email;
      }
    },
    editUser () {
      // TODO
    },
    editPassword () {
      // TODO
    },
    editAddress () {
      // TODO
    }
  }
}
</script>

