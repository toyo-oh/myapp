<template>
  <div>
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
            <td>
              <!-- https://www.nuxtjs.cn/guide/routing -->
              <!-- https://router.vuejs.org/zh/api/#router-link -->
              <router-link :to="{name: 'products-id', params: {id: item.id}}">
                <img :src="item.image" max-height="100" max-width="100">
              </router-link>
            </td>
            <td>{{ item.title }}</td>
            <td>{{ item.price }}</td>
            <!-- <td>{{ item.cnt }}</td> -->
            <td>
              <v-text-field outlined v-model.number="item.cnt" prepend-icon="mdi-minus-box-outline" append-outer-icon="mdi-plus-box-outline" @click:prepend="decrement(item)" @click:append-outer="increment(item)" min=0 max=10 :rules="countRules" oninput="if(Number(this.value) > Number(this.max)) this.value = this.max;
								if(Number(this.value) < Number(this.min)) this.value = this.min;">
              </v-text-field>
            </td>
            <td>{{ item.quantity }}</td>
            <td>
              <v-btn icon @click="showDeleteDialog(item)">
                <v-icon>mdi-delete</v-icon>
              </v-btn>
            </td>
          </tr>
        </tbody>
      </template>
    </v-simple-table>
    <v-dialog v-model="dialogDelete" max-width="200px">
      <v-card>
        <v-card-title>Delete</v-card-title>
        <v-card-text>Are you sure to delete the product?</v-card-text>
        <v-spacer></v-spacer>
        <v-card-actions>
          <v-btn color="green darken-1" text @click="removeItem()">OK</v-btn>
          <v-btn color="green darken-1" text @click="dialogDelete = false">Cancel</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-spacer></v-spacer>
    {{$store.getters['getTotalPrice']}}
    <v-btn color="error" dark large @click="checkOut">Check Out</v-btn>
  </div>
</template>

<script>
export default {
  data () {
    return {
      products: [],
      itemToDelete: '',
      dialogDelete: false,
      countRules: [
        v => !!v || "This field is required",
        v => (v && v >= 0) || "count should be above 0",
        v => (v && v <= 10) || "Max should not be above 10",
      ],
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
        this.$axios.get("api/cart/show_cart_products", {
          params: {
            ids: ids
          }
        }).then((res) => {
          this.products = res.data;
          // merge server cart to local cart 
          for (var m = 0; m < this.products.length; m++) {
            for (var n = 0; n < cartItems.length; n++) {
              if (this.products[m].id == cartItems[n].product_id) {
                this.products[m].cnt = cartItems[n].quantity;
                break;
              }
            }
            // TODO baseURL
            this.products[m].image = "http://localhost:3000" + this.products[m].image.thumb.url;
            // this.products[m].image = this.$axios.baseURL + this.products[m].image.thumb.url;
          }
        });
      }
    },

    showDeleteDialog (item) {
      this.itemToDelete = item
      this.dialogDelete = !this.dialogDelete
    },
    removeItem () {
      // remove from backend cart
      if (this.itemToDelete.cnt > 0) {
        if (this.$auth.loggedIn) {
          this.$axios.$post(`api/cart/remove_from_cart`, {
            product_id: this.itemToDelete.id,
            user_id: this.$auth.user.id
          }).then((res) => {
            console.log(res);
          });
        }
      }
      // flag
      this.dialogDelete = false
      // remove from store
      this.$store.commit('remove_product_from_cart', this.itemToDelete.id);
      this.getProductList();
    },
    increment (item) {
      if (item.cnt == 10) {
        // TODO button gray out 
        return;
      }
      if (this.$auth.loggedIn) {
        this.$axios.$post(`api/products/${item.id}/add_to_cart`, {
          product_id: item.id,
          user_id: this.$auth.user.id
        }).then((res) => {
          // console.log(res);
        });
      }
      // add to store
      var cartItem = new Object();
      cartItem.product_id = item.id;
      cartItem.price = this.price;
      this.$store.commit('add_product_to_cart', cartItem);
      this.getProductList();
    },
    decrement (item) {
      if (item.cnt == 0) {
        // TODO button gray out 
        return;
      }
      if (this.$auth.loggedIn) {
        this.$axios.$post(`api/products/${item.id}/decrease_of_cart`, {
          product_id: item.id,
          user_id: this.$auth.user.id
        }).then((res) => {
          console.log(res);
        });
      }
      // decrease of store
      var cartItem = new Object();
      cartItem.product_id = item.id;
      this.$store.commit('decrease_product_of_cart', cartItem);
      this.getProductList();
    },
    checkOut () {
      if (this.$auth.loggedIn) {
        if (!this.$store.getters['getCounter']) {
          // TODO error message (there is no product in cart)
        } else {
          this.$router.push(`/checkout`)
        }
      } else {
        this.$router.push(`/login`)
      }
    }
  },
};
</script>