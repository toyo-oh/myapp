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
              <v-icon> mdi-map-marker</v-icon>
            </v-avatar>
            <h2 class="mb-0 brown--text text--darken-3">Add New Address</h2>
          </div>
        </v-col>
        <v-col cols="3">
          <v-btn outlined color="brown lighten-1" class="text-capitalize ml-16" @click="rtnToList">
            Back To Addresses
          </v-btn>
        </v-col>
      </v-row>
      <v-row justify="center">
        <v-col cols="6">
          <address-form
            ref="addressForm"
            :receiver.sync="address.receiver"
            :phone-number.sync="address.phoneNumber"
            :post-code.sync="address.postCode"
            :prefecture-id.sync="address.prefectureId"
            :city.sync="address.city"
            :detail.sync="address.detail"
            submit-button="Create Address"
            @submit-address="createAddress()">
          </address-form>
        </v-col>
      </v-row>
    </div>
  </v-container>
</template>

<script>
import AddressForm from "@/components/inputForm/AddressForm"
export default {
  components: {
    AddressForm,
  },
  middleware: "auth",
  data() {
    return {
      alertFormError: false,
      address: {
        receiver: "",
        phoneNumber: "",
        postCode: "",
        detailAddress: "",
        prefectureId: 0,
        city: "",
        detail: "",
      },
    }
  },
  methods: {
    createAddress() {
      if (this.$refs.addressForm.validate()) {
        const formData = new FormData()
        formData.append("receiver", this.address.receiver)
        formData.append("phone_number", this.address.phoneNumber)
        formData.append("post_code", this.address.postCode)
        formData.append("city", this.address.city)
        formData.append("prefecture_id", this.address.prefectureId)
        formData.append("detail", this.address.detail)
        formData.append("user_id", this.$auth.user.hashid)
        this.$axios.post("/api/addresses", formData).then((res) => {
          if (res.data.code === "error") {
            this.$toast.error(res.data.message)
          } else {
            this.$toast.show(res.data.message)
            this.$router.push(`.`)
          }
        })
      } else {
        this.alertFormError = true
      }
    },
    rtnToList() {
      this.$router.push(`.`)
    },
  },
}
</script>
