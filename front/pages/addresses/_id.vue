<template>
  <div>
    <v-alert v-model="alertFormError" type="error" close-text="Close Alert" dismissible>
      FORM INPUT ERROR.
    </v-alert>
    <v-form ref="form" v-model="valid">
      <v-container>
        <v-row justify="center">
          <v-col cols="12" md="6">
            <v-text-field v-model="receiver" label="Receiver" type="text" :rules="receiverRules"></v-text-field>
            <v-text-field v-model="phone_number" label="PhoneNumber" type="text" :rules="phoneNumberRules"></v-text-field>
            <v-text-field v-model="post_code" label="PostCode" type="text" :rules="postCodeRules"></v-text-field>
            <v-textarea v-model="detail_address" label="DetailAddress" type="text" :rules="detailAddressRules"></v-textarea>
            <v-btn class="mr-4" color="primary" @click="editAddress">edit address</v-btn>
          </v-col>
        </v-row>
      </v-container>
    </v-form>
  </div>
</template>

<script>
export default {
  middleware: 'auth',
  data () {
    return {
      valid: true,
      alertFormError: false,
      receiverRules: [
        v => !!v || 'Receiver is required',
        v => (v && v.length <= 100) || 'Confirm Password must be less than 100 characters',
      ],
      phoneNumberRules: [
        v => !!v || 'Post Code is required',
        v => /^\d{2,4}-\d{2,4}-\d{4}$/.test(v) || 'Phone Number must be valid',
      ],
      postCodeRules: [
        v => !!v || 'Phone number is required',
        v => /^[0-9]{3}-[0-9]{4}$/.test(v) || 'Post Code must be valid',
      ],
      detailAddressRules: [
        v => !!v || 'Detail Address is required',
        v => (v && v.length <= 200) || 'Confirm Password must be less than 200 characters',
      ],
    };
  },
  asyncData ({ $axios, params }) {
    return $axios.$get(`/api/addresses/${params.id}`).then((res) => {
      return {
        id: res.id,
        receiver: res.receiver,
        phone_number: res.phone_number,
        post_code: res.post_code,
        detail_address: res.detail_address
      };
    });
  },
  methods: {
    editAddress () {
      if (this.$refs.form.validate()) {
        const formData = new FormData();
        formData.append("id", this.id);
        formData.append("receiver", this.receiver);
        formData.append("phone_number", this.phone_number);
        formData.append("post_code", this.post_code);
        formData.append("detail_address", this.detail_address);
        this.$axios.put(`/api/addresses/${this.id}`, formData).then((res) => {
          this.$router.push(`.`);
        });
      } else {
        this.alertFormError = true;
      }
    },
  },
};
</script>