<template>
  <v-container>
    <div>
      <v-row justify="center">
        <v-col cols="3">
          <div class="d-flex align-center">
            <v-avatar tile size="25" class="me-3">
              <v-icon> mdi-account</v-icon>
            </v-avatar>
            <h2 class="mb-0 brown--text text--darken-3">My Profile</h2>
          </div>
        </v-col>
        <v-col cols="3"> </v-col>
      </v-row>
      <v-row justify="center">
        <v-col cols="6">
          <v-card class="mb-4">
            <div class="pa-4 d-flex align-center justify-space-between">
              <div class="flex-1 mr-3">
                <h4 class="mb-0 brown--text text--lighten-1">Profile</h4>
              </div>
              <div class="flex-1 mr-3">
                <p class="mb-0">{{ name }}</p>
              </div>
              <v-btn small outlined color="brown lighten-1" class="mr-2" @click="editProfile()"
                >Change</v-btn
              >
            </div>
          </v-card>
          <v-card class="mb-4">
            <div class="pa-4 d-flex align-center justify-space-between">
              <div class="flex-1 mr-3">
                <h4 class="mb-0 brown--text ltext--ighten-1">Email</h4>
              </div>
              <div class="flex-1 mr-3">
                <p class="mb-0">{{ email }}</p>
              </div>
              <v-btn small outlined color="brown lighten-1" class="mr-2" @click="editEmail()"
                >Change</v-btn
              >
            </div>
          </v-card>
          <v-card class="mb-4">
            <div class="pa-4 d-flex align-center justify-space-between">
              <div class="flex-1 mr-3">
                <h4 class="mb-0 brown--text ltext--ighten-1">Password</h4>
              </div>
              <div class="flex-1 mr-3">
                <p class="mb-0">********</p>
              </div>
              <v-btn small outlined color="brown lighten-1" class="mr-2" @click="editPassword()"
                >Change</v-btn
              >
            </div>
          </v-card>
        </v-col>
      </v-row>
    </div>
  </v-container>
</template>

<script>
export default {
  middleware: "auth",
  data() {
    return {
      name: "",
      email: "",
    }
  },
  created() {
    this.loadUserData()
  },
  methods: {
    loadUserData() {
      this.$axios
        .$get(`/api/users/${this.$auth.user.hashid}`)
        .then((res) => {
          this.name = res.user.name
          this.email = res.user.email
        })
        .catch((err) => {
          if (err.response && err.response.status === 401) {
            this.$router.push(`/users/${this.$auth.user.hashid}`)
            this.$toast.error("Unauthorized!")
          }
        })
    },
    editProfile() {
      this.$router.push({ path: "/users/change_profile" })
    },
    editEmail() {
      this.$router.push({ path: "/users/change_email" })
    },
    editPassword() {
      this.$router.push({ path: "/users/change_password" })
    },
  },
}
</script>
