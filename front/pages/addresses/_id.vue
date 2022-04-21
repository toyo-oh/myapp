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
            <h2 class="mb-0">Edit My Addresses</h2>
          </div>
        </v-col>
        <v-col cols="3">
          <v-btn outlined color="brown lighten-1" class="text-capitalize ml-16" @click="rtnToList">
            Back To Addresses
          </v-btn>
        </v-col>
      </v-row>
      <v-row justify="center">
        <v-col cols="12" md="6">
          <address-form ref="addressForm" :receiver.sync="address.receiver" :phoneNumber.sync="address.phoneNumber" :postCode.sync="address.postCode" :prefectureId.sync="address.prefectureId" :city.sync="address.city" :detail.sync="address.detail" submitButton="Save Changes" @submit-address="editAddress()">
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
      valid: true,
      alertFormError: false,
      address: {
        receiver: '',
        phoneNumber: '',
        postCode: '',
        prefectureId: 0,
        city: '',
        detail: '',
      }
    };
  },
  created () {
    this.loadAddress();
  },
  methods: {
    loadAddress () {
      this.$axios.$get(`/api/addresses/${this.$route.params.id}`).then((res) => {
        this.address.hashid = res.hashid;
        this.address.receiver = res.receiver;
        this.address.phoneNumber = res.phone_number;
        this.address.postCode = res.post_code;
        this.address.prefectureId = res.prefecture_id;
        this.address.city = res.city;
        this.address.detail = res.detail;
      }).catch((err) => {
        if (err.response && err.response.status === 401) {
          this.$router.push('/addresses');
          this.$toast.error('Unauthorized!');
        }
      });
    },
    editAddress () {
      if (this.$refs.addressForm.validate()) {
        const formData = new FormData();
        formData.append("hashid", this.address.hashid);
        formData.append("receiver", this.address.receiver);
        formData.append("phone_number", this.address.phoneNumber);
        formData.append("post_code", this.address.postCode);
        formData.append("city", this.address.city);
        formData.append("prefecture_id", this.address.prefectureId);
        formData.append("detail", this.address.detail);
        this.$axios.put(`/api/addresses/${this.address.hashid}`, formData).then((res) => {
          if (res.data.code === "error") {
            this.$toast.error(res.data.message);
          } else {
            this.$toast.show(res.data.message);
            this.$router.push(`.`);
          }
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