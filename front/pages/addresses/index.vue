<template>
  <div>
    <v-btn class="mr-4" color="primary" @click="newAddress">New Address</v-btn>
    <v-spacer></v-spacer>
    <v-data-table :headers="headers" :items="addresses">
      <template v-slot:item.edit="{ item }">
        <v-icon small class="mr-2" @click="editAddress(item)">mdi-pencil</v-icon>
      </template>
      <template v-slot:item.delete="{ item }">
        <v-icon small @click="showDeleteDialog(item)">mdi-close-circle-outline</v-icon>
      </template>
      <!-- <v-btn elevation="2" @click="setDefault(item)">Default</v-btn> -->
    </v-data-table>
    <v-dialog v-model="dialogDelete" max-width="200px">
      <v-card>
        <v-card-title>Delete</v-card-title>
        <v-card-text>Are you sure to delete the address?</v-card-text>
        <v-spacer></v-spacer>
        <v-card-actions>
          <v-btn color="green darken-1" text @click="deleteAddress()">OK</v-btn>
          <v-btn color="green darken-1" text @click="dialogDelete = false">Cancel</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
export default {
  middleware: 'auth',
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
      dialogDelete: false,
      itemToDelete: ''
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
    showDeleteDialog (item) {
      this.itemToDelete = item
      this.dialogDelete = !this.dialogDelete
    },
    deleteAddress () {
      this.$axios
        .delete(`api/addresses/${this.itemToDelete.id}`)
        .then((res) => {
          this.getAddresses();
        });
      this.dialogDelete = false
    },
    newAddress () {
      this.$router.push(`addresses/new`)
    }
  },
};
</script>