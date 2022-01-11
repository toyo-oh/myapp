<template>
  <div>
    <v-btn class="mr-4" color="primary" @click="newProduct">New Product</v-btn>
    <v-spacer></v-spacer>
    <v-data-table :headers="headers" :items="products">
      <template v-slot:item.edit="{ item }">
        <v-icon small class="mr-2" @click="editProduct(item)">mdi-pencil</v-icon>
      </template>
      <!-- <template v-slot:[`item.delete`]="{ item }"> -->
      <template v-slot:item.delete="{ item }">
        <v-icon small @click="showDeleteDialog(item)">mdi-delete</v-icon>
      </template>
    </v-data-table>
    <v-dialog v-model="dialogDelete" max-width="200px">
      <v-card>
        <v-card-title>Delete</v-card-title>
        <v-card-text>Are you sure to delete the product?</v-card-text>
        <v-spacer></v-spacer>
        <v-card-actions>
          <v-btn color="green darken-1" text @click="deleteProduct()">OK</v-btn>
          <v-btn color="green darken-1" text @click="dialogDelete = false">Cancel</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
export default {
  middleware: ['auth', 'admin'],
  data () {
    return {
      headers: [
        { text: "Title", align: "start", sortable: false, value: "title" },
        { text: "Description", value: "description" },
        { text: "Price", value: "price" },
        { text: "Quantity", value: "quantity" },
        { text: "Edit", value: "edit", sortable: false },
        { text: "Delete", value: "delete", sortable: false },
      ],
      products: [],
      dialogDelete: false,
      itemToDelete: ''
    };
  },
  // TODO 变为asyncData方法获取初始数据
  created () {
    this.getProducts();
  },
  methods: {
    getProducts () {
      this.$axios.get("api/admin/products").then((res) => {
        this.products = res.data;
      });
    },
    editProduct (item) {
      this.$router.push(`products/${item.id}`)
    },
    showDeleteDialog (item) {
      this.itemToDelete = item
      this.dialogDelete = !this.dialogDelete
    },
    deleteProduct () {
      this.$axios
        .delete(`api/admin/products/${this.itemToDelete.id}`)
        .then((res) => {
          this.getProducts()
        });
      this.dialogDelete = false;
    },
    newProduct () {
      this.$router.push(`products/new`)
    }
  },
};
</script>