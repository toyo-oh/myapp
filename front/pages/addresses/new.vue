<template>
  <v-container>
    <div>
      <v-alert v-model="alertFormError" type="error" close-text="Close Alert" dismissible>
        FORM INPUT ERROR.
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
          <v-form ref="form" v-model="valid">
            <v-text-field outlined　dense color="brown lighten-3" v-model="receiver" label="Receiver" type="text" :rules="receiverRules"></v-text-field>
            <v-text-field outlined　dense color="brown lighten-3" v-model="phone_number" label="PhoneNumber" type="text" :rules="phoneNumberRules"></v-text-field>
            <v-text-field outlined　dense color="brown lighten-3" v-model="post_code" label="PostCode" type="text" :rules="postCodeRules"></v-text-field>
            <v-textarea outlined　dense color="brown lighten-3" v-model="detail_address" label="DetailAddress" type="text" :rules="detailAddressRules"></v-textarea>
            <v-btn dark class="mr-4" color="brown lighten-1" @click="createAddress">create address</v-btn>
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
      receiver: "",
      phone_number: "",
      post_code: "",
      detail_address: "",
      receiverRules: [
        v => !!v || 'Receiver is required',
        v => (v && v.length <= 20) || 'Receiver must be less than 20 characters',
      ],
      phoneNumberRules: [
        v => !!v || 'Post Number is required',
        v => /^\d{2,4}-\d{2,4}-\d{4}$/.test(v) || 'Phone Number must be valid',
      ],
      postCodeRules: [
        v => !!v || 'Phone Code is required',
        v => /^[0-9]{3}-[0-9]{4}$/.test(v) || 'Post Code must be valid',
      ],
      detailAddressRules: [
        v => !!v || 'Detail Address is required',
        v => (v && v.length <= 100) || 'Detail Address must be less than 100 characters',
      ],
    };
  },
  methods: {
    createAddress () {
      if (this.$refs.form.validate()) {
        const formData = new FormData();
        formData.append("receiver", this.receiver);
        formData.append("phone_number", this.phone_number);
        formData.append("post_code", this.post_code);
        formData.append("detail_address", this.detail_address);
        formData.append("user_id", this.$auth.user.id)
        this.$axios.post("/api/addresses", formData).then((res) => {
          this.$router.push(`.`);
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