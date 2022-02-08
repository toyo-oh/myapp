<template>
  <div>
    <v-alert v-model="alertNoItem" type="error" close-text="Close Alert" dismissible>
      There are no items in the shopping cart.
    </v-alert>
    <v-alert v-model="alertNoPrefecture" type="error" close-text="Close Alert" dismissible>
      Please select Prefecture.
    </v-alert>
    <v-row>
      <v-col cols="12">
        <v-row>
          <div v-if="products.length==0" class="ml-12 mt-6 d-flex align-center">
            <img src="@/assets/images/cart/empty_cart.jpg" width="400" height="300">
            <h2 class="brown--text text--darken-4">
              Your shopping cart is empty. Start shopping
              <router-link to="home">Here</router-link>
            </h2>
          </div>
        </v-row>
      </v-col>
      <v-col cols="12">
        <v-row>
          <v-col cols="12" md="6" lg="8" xl="8">
            <div v-for="item in products" :key="item.id">
              <base-card class="d-flex flex-wrap mb-6">
                <router-link :to="{name: 'products-id', params: {id: item.id}}">
                  <img :src="item.image" max-height="100" max-width="100" alt="">
                </router-link>
                <div class="d-flex flex-column flex-grow-1 flex-wrap pa-4 mw-0">
                  <div class="d-flex justify-space-between w-100 mb-3">
                    <div>
                      <div class="d-flex">
                        <h4 class="text-truncate mb-4">{{item.title}}</h4>
                      </div>
                      <div>
                        <p class="grey--text text--darken-1 mb-0">¥{{item.price}} x {{ item.cnt }}
                          <span class="brown--text text--darken-4 ms-2">¥{{item.price * item.cnt}}</span>
                        </p>
                      </div>
                    </div>
                    <v-btn icon @click="showDeleteDialog(item)">
                      <v-icon>mdi-close</v-icon>
                    </v-btn>
                  </div>
                  <div class="d-flex justify-end flex-grow-1 align-end">
                    <div class="d-flex align-center">
                      <v-btn class="rounded " outlined fab x-small tile color="brown lighten-1" @click="decrement(item)" :disabled="item.isMinusDisable">
                        <v-icon>mdi-minus</v-icon>
                      </v-btn>
                      <div class="text-center mx-2">{{ item.cnt }}</div>
                      <v-btn class="rounded" outlined fab x-small tile color="brown lighten-1" @click="increment(item)" :disabled="item.isPlusDisable">
                        <v-icon>mdi-plus</v-icon>
                      </v-btn>
                    </div>
                  </div>
                </div>
              </base-card>
            </div>
          </v-col>
          <v-col cols="12" md="6" lg="4" xl="4">
            <base-card v-if="products.length>0">
              <div class="pa-5">
                <div class="d-flex justify-space-between">
                  <p class="mb-0 grey--text text--darken-1">Total</p>
                  <h4>¥{{$store.getters['getTotalPrice'] + this.shipping_fee}}</h4>
                </div>
                <v-divider class="my-3"></v-divider>
                <h4 class="mb-4">Shipping Estimates</h4>
                <p class="text-14 mb-1">Prefecture</p>
                <v-select dense outlined hide-details color="brown lighten-1" class="mb-4" :items="prefectures" item-text="prefecture" item-value="id" v-model="prefecture_id" label="Select Prefecture"></v-select>
                <v-btn color="brown lighten-1" outlined class="text-capitalize mb-4" block @click="calShipping">
                  Calculate Shipping
                </v-btn>
                <div class="d-flex justify-space-between">
                  <p class="mb-4">Shipping Fee</p>
                  <h4>{{"¥"+shipping_fee}}</h4>
                </div>
                <v-btn dark color="brown lighten-1" class="text-capitalize mb-4" block @click="checkOut">
                  Checkout Now
                </v-btn>
              </div>
            </base-card>
          </v-col>
        </v-row>
      </v-col>
    </v-row>
    <v-dialog v-model="dialogDelete" max-width="200px">
      <v-card>
        <v-card-title>Delete</v-card-title>
        <v-card-text>Are you sure to delete the product?</v-card-text>
        <v-spacer></v-spacer>
        <v-card-actions>
          <v-btn color="brown lighten-1" text @click="removeItem()">OK</v-btn>
          <v-btn color="brown lighten-1" text @click="dialogDelete = false">Cancel</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
export default {
  data () {
    return {
      cardHoverShadow: true,
      products: [],
      itemToDelete: '',
      dialogDelete: false,
      alertNoItem: false,
      countRules: [
        v => !!v || "This field is required",
        v => (v && v >= 0) || "count should be above 0",
        v => (v && v <= 10) || "Max should not be above 10",
      ],
      prefectures: [],
      prefecture_id: '',
      shipping_fee: 0,
      alertNoPrefecture: false
    };
  },
  created () {
    this.getProductList();
    this.loadPrefectures();
  },
  computed: {
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
                // set button 
                this.products[m].isMinusDisable = this.isMinusDisable(this.products[m]);
                this.products[m].isPlusDisable = this.isPlusDisable(this.products[m]);
                break;
              }
            }
            // TODO baseURL
            this.products[m].image = "http://localhost:3000" + this.products[m].image.thumb.url;
            // this.products[m].image = this.$axios.baseURL + this.products[m].image.thumb.url;
          }
          console.log(this.products);
        });
      }
    },
    loadPrefectures () {
      this.$axios.get(`/api/prefectures`).then((res) => {
        this.prefectures = res.data;
      });
    },
    isMinusDisable (item) {
      return item.cnt < 2 ? true : false
    },
    isPlusDisable (item) {
      return item.cnt == 10 || item.cnt == item.quantity ? true : false
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
            // console.log(res);
            // TODO
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
      if (item.cnt == 10 || item.cnt == item.quantity) {
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
      if (item.cnt < 2) {
        // TODO button gray out 
        return;
      }
      if (this.$auth.loggedIn) {
        this.$axios.$post(`api/products/${item.id}/decrease_of_cart`, {
          product_id: item.id,
          user_id: this.$auth.user.id
        }).then((res) => {
          // TODO
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
          this.alertNoItem = true;
        } else {
          // this.$refs.wizard.nextTab();
          this.$router.push(`/checkout`)
        }
      } else {
        this.$router.push(`/login`)
      }
    },
    calShipping () {
      if (this.prefecture_id) {
        this.$axios.get(`/api/shipping_fees/${this.prefecture_id}`).then((res) => {
          this.shipping_fee = res.data.fee;
        });
      } else {
        this.alertNoPrefecture = true;
      }
    }
  },
};
</script>