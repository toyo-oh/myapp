<template>
  <div>
    <div class="d-flex justify-space-between flex-wrap mb-5">
      <div class="d-flex align-center ">
        <v-avatar tile size="25" class="me-3">
          <v-icon> mdi-map-marker</v-icon>
        </v-avatar>
        <h2 class="mb-0 brown--text text--darken-3">My Addresses</h2>
      </div>
      <v-btn outlined color="brown lighten-1" class="text-capitalize" @click="newAddress">
        Add New Address
      </v-btn>
    </div>
    <!-- <v-btn class="mr-4" dark color="brown lighten-1" @click="newAddress">New Address</v-btn> -->
    <v-spacer></v-spacer>
    <v-data-table :headers="headers" :items="addresses" :page.sync="page" :items-per-page="itemsPerPage" hide-default-footer>
      <template v-slot:item.receiver="{ item }">
        <h4 class="mb-0">{{item.receiver}}</h4>
      </template>
      <template v-slot:item.edit="{ item }">
        <v-icon small class="mr-2" @click="editAddress(item)">mdi-pencil</v-icon>
      </template>
      <template v-slot:item.delete="{ item }">
        <v-icon small @click="showDeleteDialog(item)">mdi-delete</v-icon>
      </template>
      <!-- <v-btn elevation="2" @click="setDefault(item)">Default</v-btn> -->
    </v-data-table>
    <div class="text-center pt-2">
      <v-pagination color="brown lighten-1" v-model="page" :length="pageCount"></v-pagination>
    </div>
    <v-dialog v-model="dialogDelete" max-width="200px">
      <v-card>
        <v-card-title>Delete</v-card-title>
        <v-card-text>Are you sure to delete the address?</v-card-text>
        <v-spacer></v-spacer>
        <v-card-actions>
          <v-btn color="brown lighten-1" text @click="deleteAddress()">OK</v-btn>
          <v-btn color="brown lighten-1" text @click="dialogDelete = false">Cancel</v-btn>
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
      page: 1,
      pageCount: 0,
      itemsPerPage: 10,
      headers: [
        { text: "Receiver", value: "receiver", align: "start", sortable: false, class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
        { text: "PhoneNumber", value: "phone_number", sortable: false, class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
        { text: "PostCode", value: "post_code", sortable: false, class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
        { text: "Address", value: "detail_address", sortable: false, class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
        { text: "Edit", value: "edit", sortable: false, class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
        { text: "Delete", value: "delete", sortable: false, class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
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
        this.pageCount = Math.ceil(res.data.length / this.itemsPerPage);
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