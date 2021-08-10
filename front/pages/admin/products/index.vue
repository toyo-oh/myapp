<template>
  <!-- <v-btn small raised color="primary">New Product</v-btn>
    <v-spacer></v-spacer> -->
  <v-data-table :headers="headers" :items="products">
    <template v-slot:item.action="{ item }">
      <v-icon small class="mr-2" @click="editItem(item)"> mdi-pencil </v-icon>
    </template>
    <template v-slot:item.action="{ item }">
      <v-icon small @click="deleteItem(item)"> mdi-delete </v-icon>
    </template>
    <template v-slot:item.action="{ item }">
      <v-btn>Created Button</v-btn>
    </template>
  </v-data-table>
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
    editProduct() {},
    deleteProduct() {},
  },
};
</script>