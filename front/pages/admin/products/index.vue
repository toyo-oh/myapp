<template>
  <div>
    <div class="d-flex justify-space-between flex-wrap mb-5">
      <div class="d-flex align-center ">
        <v-avatar tile size="25" class="me-3">
          <v-icon>mdi-cube-outline</v-icon>
        </v-avatar>
        <h2 class="mb-0">Product List</h2>
      </div>
      <v-btn outlined color="brown lighten-1" class="text-capitalize" @click="newProduct">
        Add New Product
      </v-btn>
    </div>
    <!-- <v-spacer></v-spacer> -->
    <v-data-table :headers="headers" :items="products" :page.sync="page" :items-per-page="itemsPerPage" hide-default-footer>
      <template v-slot:[`item.edit`]="{ item }">
        <v-icon small class="mr-2" @click="editProduct(item)">mdi-pencil</v-icon>
      </template>
      <template v-slot:[`item.delete`]="{ item }">
        <v-icon small @click="showDeleteDialog(item)">mdi-delete</v-icon>
      </template>
    </v-data-table>
    <div class="text-center pt-2">
      <v-pagination color="brown lighten-1" v-model="page" :length="pageCount"></v-pagination>
    </div>
    <v-dialog v-model="dialogDelete" max-width="200px">
      <v-card>
        <v-card-title>Delete</v-card-title>
        <v-card-text>Are you sure to delete the product?</v-card-text>
        <v-spacer></v-spacer>
        <v-card-actions>
          <v-btn color="brown lighten-1" text @click="deleteProduct()">OK</v-btn>
          <v-btn color="brown lighten-1" text @click="dialogDelete = false">Cancel</v-btn>
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
      page: 1,
      pageCount: 0,
      itemsPerPage: 9,
      headers: [
        { text: "ID", align: "start", sortable: false, value: "hashid", class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
        { text: "Title", align: "start", sortable: false, value: "title", class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
        { text: "SubTitle", value: "sub_title", sortable: false, class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
        { text: "Category", value: "category_id", sortable: false, class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
        { text: "Price", value: "price", sortable: false, class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
        { text: "Quantity", value: "quantity", sortable: false, class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
        { text: "Edit", value: "edit", sortable: false, class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
      ],
      products: [],
      dialogDelete: false,
      itemToDelete: ''
    };
  },
  created () {
    this.getProducts();
  },
  methods: {
    getProducts () {
      this.$axios.get("api/admin/products").then((res) => {
        this.products = res.data.products;
        this.pageCount = Math.ceil(res.data.products.length / this.itemsPerPage);
      });
    },
    editProduct (item) {
      this.$router.push(`products/${item.hashid}`)
    },
    showDeleteDialog (item) {
      this.itemToDelete = item
      this.dialogDelete = !this.dialogDelete
    },
    deleteProduct () {
      this.$axios
        .delete(`api/admin/products/${this.itemToDelete.hashid}`)
        .then(() => {
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