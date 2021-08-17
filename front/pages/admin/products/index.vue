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
            <v-icon small @click="deleteProduct(item)">mdi-delete</v-icon>
        </template>
        </v-data-table>
    </div>
</template>

<script>
export default {
  data() {
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
    };
  },
  created() {
    this.getProducts();
  },
  methods: {
    getProducts() {
      this.$axios.get("api/admin/products").then((res) => {
        this.products = res.data;
      });
    },
    editProduct(item) {
        this.$router.push(`products/${item.id}`)
    },
    deleteProduct(item) {
      this.$axios
        .delete(`api/admin/products/${item.id}`)
        .then((res) => {
            this.getProducts()
        });
    },
    newProduct(){
        this.$router.push(`products/new`)
    }
  },
};
</script>