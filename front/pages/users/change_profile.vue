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
          <v-btn
            outlined
            color="brown lighten-1"
            class="text-capitalize ml-16"
            @click="rtnToProfile">
            Back To My Profile
          </v-btn>
        </v-col>
      </v-row>
      <v-row justify="center">
        <v-col cols="6">
          <v-form ref="form" v-model="valid">
            <v-text-field
              v-model="name"
              outlined
              dense
              color="brown lighten-3"
              label="Name"
              :rules="nameRules"
              type="text"></v-text-field>
            <v-text-field
              v-model="phoneNumber"
              outlined
              dense
              color="brown lighten-3"
              label="Phone Number"
              type="text"
              :rules="phonenumberRules"></v-text-field>
            <v-text-field
              v-model="email"
              outlined
              dense
              color="brown lighten-3"
              label="Email"
              type="text"
              disabled></v-text-field>
            <v-btn dark class="mr-4" color="brown lighten-1" @click="updateProfile"
              >Save Changes
            </v-btn>
          </v-form>
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
      valid: true,
      alertFormError: false,
      name: "",
      phoneNumber: "",
      email: "",
      nameRules: [
        (v) => !!v || "Name is required",
        (v) => (v && v.length <= 20) || "Name must be less than 20 characters",
      ],
      phonenumberRules: [(v) => /^\d{2,4}-\d{2,4}-\d{4}$/.test(v) || "Phone Number must be valid"],
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
          this.phoneNumber = res.user.phone_number
        })
        .catch((err) => {
          if (err.response && err.response.status === 401) {
            this.$toast.error("Unauthorized!")
          }
        })
    },
    updateProfile() {
      if (this.$auth.loggedIn) {
        if (this.$refs.form.validate()) {
          this.$axios
            .post(`/api/users/${this.$auth.user.hashid}/update_profile`, {
              name: this.name,
              phone_number: this.phoneNumber,
              hashid: this.$auth.user.hashid,
            })
            .then((res) => {
              if (res.data.code === "error") {
                this.$toast.error(res.data.message)
              } else {
                this.$toast.show(res.data.message)
                this.$router.push(`/users/${this.$auth.user.hashid}`)
              }
            })
            .catch((err) => {
              if (err.response && err.response.status === 401) {
                this.$router.push(`/users/${this.$auth.user.hashid}`)
                this.$toast.error("Unauthorized!")
              }
            })
        } else {
          this.alertFormError = true
        }
      } else {
        this.$router.push("/login")
      }
    },
    rtnToProfile() {
      this.$router.push(`/users/${this.$auth.user.hashid}`)
    },
  },
}
</script>
