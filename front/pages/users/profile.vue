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
            <h2 class="mb-0">Edit Profile</h2>
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
            <v-text-field outlined　dense color="brown lighten-3" v-model="name" label="Name" :rules="nameRules" type="text"></v-text-field>
            <v-text-field outlined　dense color="brown lighten-3" v-model="phoneNumber" label="Phone Number" type="text" :rules="phonenumberRules"></v-text-field>
            <v-text-field outlined　dense color="brown lighten-3" v-model="email" label="Email" type="text" disabled></v-text-field>
            <v-btn dark class="mr-4" color="brown lighten-1" @click="updateProfile">Save Changes</v-btn>
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
      name: '',
      phoneNumber: '',
      email: '',
      nameRules: [
        v => !!v || 'Name is required',
        v => (v && v.length <= 20) || 'Name must be less than 20 characters',
      ],
      phonenumberRules: [
        // TODO
        v => (/^\d{2,4}-\d{2,4}-\d{4}$/.test(v)) || 'Phone Number must be valid',
      ]
    }
  },
  created () {
    this.loadUserData();
  },
  methods: {
    async loadUserData () {
      if (this.$auth.loggedIn) {
        const response = await this.$axios.$get(`/api/users/${this.$auth.user.id}`);
        this.name = response.user.name;
        this.email = response.user.email;
        this.phoneNumber = response.user.phone_number;
      }
    },
    updateProfile () {
      if (this.$auth.loggedIn) {
        if (this.$refs.form.validate()) {
          this.$axios.post(`/api/users/${this.$auth.user.id}/profile`, {
            name: this.name,
            phone_number: this.phoneNumber,
            id: this.$auth.user.id
          }).then((res) => {
            this.$router.push(`/users/${this.$auth.user.id}`)
          })
        } else {
          this.alertFormError = true;
        }
      }
    },
    rtnToProfile () {
      this.$router.push(`/users/${this.$auth.user.id}`)
    }
  }
}
</script>