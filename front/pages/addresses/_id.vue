<template>
  <v-form>
    <v-container>
      <v-row justify="center">
        <v-col cols="12" md="6">
          <v-text-field v-model="receiver" label="Receiver" type="text"></v-text-field>
          <v-text-field v-model="phone_number" label="PhoneNumber" type="text"></v-text-field>
          <v-text-field v-model="post_code" label="PostCode" type="text"></v-text-field>
          <v-textarea v-model="detail_address" label="DetailAddress" type="text"></v-textarea>
          <v-btn class="mr-4" color="primary" @click="editAddress">edit address</v-btn>
        </v-col>
      </v-row>
    </v-container>
  </v-form>
</template>

<script>
export default {
  middleware: 'auth',
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
      const formData = new FormData();
      formData.append("id", this.id);
      formData.append("receiver", this.receiver);
      formData.append("phone_number", this.phone_number);
      formData.append("post_code", this.post_code);
      formData.append("detail_address", this.detail_address);
      this.$axios.put(`/api/addresses/${this.id}`, formData).then((res) => {
        this.$router.push(`.`);
      });
    },
  },
};
</script>