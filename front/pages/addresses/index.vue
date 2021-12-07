<template>
  <div>
    <v-btn class="mr-4" color="primary" @click="newAddress">New Address</v-btn>
    <v-spacer></v-spacer>
    <v-data-table :headers="headers" :items="addresses">
      <template v-slot:item.edit="{ item }">
        <v-icon small class="mr-2" @click="editAddress(item)">mdi-pencil</v-icon>
      </template>
      <template v-slot:item.delete="{ item }">
        <v-icon small @click="deleteAddress(item)">mdi-delete</v-icon>
      </template>
    </v-data-table>
  </div>
</template>

<script>
export default {
  data () {
    return {
      headers: [
        { text: "Receiver", align: "start", sortable: false, value: "receiver" },
        { text: "PhoneNumber", value: "phone_number" },
        { text: "PostCode", value: "post_code" },
        { text: "Address", value: "detail_address" },
        { text: "Edit", value: "edit", sortable: false },
        { text: "Delete", value: "delete", sortable: false },
      ],
      addresses: [],
    };
  },
  // TODO 变为asyncData方法获取初始数据
  created () {
    this.getAddresses();
  },
  methods: {
    getAddresses () {
      this.$axios.get(`api/addresses/find_by_user_id/${this.$auth.user.id}`).then((res) => {
        this.addresses = res.data;
      });
    },
    editAddress (item) {
      this.$router.push(`addresses/${item.id}`)
    },
    deleteAddress (item) {
      this.$axios
        .delete(`api/addresses/${item.id}`)
        .then((res) => {
          this.getAddresses()
        });
    },
    newAddress () {
      this.$router.push(`addresses/new`)
    }
  },
};
</script>