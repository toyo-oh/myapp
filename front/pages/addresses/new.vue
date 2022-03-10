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
          <address-form ref="addressForm" :receiver.sync="address.receiver" :phoneNumber.sync="address.phoneNumber" :postCode.sync="address.postCode" :prefectureId.sync="address.prefectureId" :city.sync="address.city" :detail.sync="address.detail" submitButton="Create Address" @submit-address="createAddress()">
          </address-form>
        </v-col>
      </v-row>
    </div>
  </v-container>
</template>

<script>
import AddressForm from "@/components/inputForm/AddressForm";
export default {
  middleware: 'auth',
  components: {
    AddressForm,
  },
  data () {
    return {
      alertFormError: false,
      address: {
        receiver: '',
        phoneNumber: '',
        postCode: '',
        detailAddress: '',
        prefectureId: 0,
        city: '',
        detail: ''
      }
    };
  },
  methods: {
    createAddress () {
      if (this.$refs.addressForm.validate()) {
        const formData = new FormData();
        formData.append("receiver", this.address.receiver);
        formData.append("phone_number", this.address.phoneNumber);
        formData.append("post_code", this.address.postCode);
        formData.append("city", this.address.city);
        formData.append("prefecture_id", this.address.prefectureId);
        formData.append("detail", this.address.detail);
        formData.append("user_id", this.$auth.user.id);
        this.$axios.post("/api/addresses", formData).then(() => {
          this.$router.push(`.`);
          this.$toast.show('Create address Successfully!');
        });
      } else {
        this.alertFormError = true;
      }
    },
    rtnToList () {
      this.$router.push(`.`);
    }
  },
};
</script>