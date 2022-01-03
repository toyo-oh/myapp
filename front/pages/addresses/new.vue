<template>
  <v-form>
    <v-container>
      <v-row justify="center">
        <v-col cols="12" md="6">
          <v-text-field v-model="receiver" label="Receiver" type="text"></v-text-field>
          <v-text-field v-model="phone_number" label="PhoneNumber" type="text"></v-text-field>
          <v-text-field v-model="post_code" label="PostCode" type="text"></v-text-field>
          <v-textarea v-model="detail_address" label="DetailAddress" type="text"></v-textarea>
          <v-btn class="mr-4" color="primary" @click="createAddress">create address</v-btn>
        </v-col>
      </v-row>
    </v-container>
  </v-form>
</template>

<script>
export default {
  middleware: 'auth',
  data () {
    return {
      receiver: "",
      phone_number: "",
      post_code: "",
      detail_address: ""
    };
  },
  methods: {
    createAddress () {
      const formData = new FormData();
      formData.append("receiver", this.receiver);
      formData.append("phone_number", this.phone_number);
      formData.append("post_code", this.post_code);
      formData.append("detail_address", this.detail_address);
      formData.append("user_id", this.$auth.user.id)
      this.$axios.post("/api/addresses", formData).then((res) => {
        this.$router.push(`.`);
      });
    },
  },
};
</script>