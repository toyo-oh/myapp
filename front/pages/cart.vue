<template>
  <div>
    <!-- <v-data-table :headers="headers" :items="products">
      <template v-slot:item.delete="{ item }">
        <v-icon small @click="deleteProduct(item)">mdi-delete</v-icon>
      </template>
    </v-data-table> -->

    <v-simple-table>
      <template v-slot:default>
        <thead>
          <tr>
            <th></th>
            <th>Title</th>
            <th>Price</th>
            <th>Count</th>
            <th>Quantity</th>
            <th>Delete</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in products" :key="item.id">
            <td><img :src="item.image" max-height="100" max-width="100"></td>
            <td>{{ item.title }}</td>
            <td>{{ item.price }}</td>
            <td>{{ item.cnt }}</td>
            <td>{{ item.quantity }}</td>
            <td>
              <v-btn icon>
                <v-icon>mdi-delete</v-icon>
              </v-btn>
            </td>
          </tr>
        </tbody>
      </template>
    </v-simple-table>

    <v-spacer></v-spacer>
    <v-btn class="mr-4" color="primary" @click="checkOut">Check Out</v-btn>
  </div>
</template>

<script>
export default {
  data () {
    return {
      headers: [
        { text: "Description", value: "description", sortable: false },
        { text: "Price", value: "price", sortable: false },
        { text: "Count", value: "cnt", sortable: false },
        { text: "Quantity", value: "quantity", sortable: false },
        { text: "Delete", value: "delete", sortable: false },
      ],
      products: [],
    };
  },
  created () {
    this.getProductList();
  },
  methods: {
    getProductList () {
      var cartItems = JSON.parse(localStorage.getItem('Cart'));
      if (cartItems.length == 0) {
        this.products = [];
      } else {
        var ids = [];
        for (var i = 0; i < cartItems.length; i++) {
          ids.push(cartItems[i].product_id);
        }
        this.$axios.get("api/product/show_cart_products", {
          params: {
            ids: ids
          }
        }).then((res) => {
          this.products = res.data;
          for (var m = 0; m < this.products.length; m++) {
            for (var n = 0; n < cartItems.length; n++) {
              if (this.products[m].id == cartItems[n].product_id) {
                this.products[m].cnt = cartItems[n].quantity;
                break;
              }
            }
            this.products[m].image = "http://localhost:3000" + this.products[m].image.thumb.url;
          }
        });
      }
    },
    deleteProduct (item) {
    },
    checkOut () {
    }
  },
};
</script>