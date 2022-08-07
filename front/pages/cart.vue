<template>
  <div>
    <v-row>
      <v-col cols="12">
        <v-row>
          <div v-if="products.length == 0" class="ml-12 mt-6 d-flex align-center">
            <img src="@/assets/images/cart/empty_cart.jpg" width="400" height="300" />
            <h2 class="brown--text text--darken-4">
              Your shopping cart is empty. Start shopping
              <router-link to="home">Here</router-link>
            </h2>
          </div>
        </v-row>
      </v-col>
      <v-col cols="12">
        <v-row>
          <v-col cols="8">
            <div v-for="item in products" :key="item.id">
              <v-card class="d-flex flex-wrap mb-6">
                <router-link :to="{ name: 'products-id', params: { id: item.hashid } }">
                  <img :src="item.images[0].thumb.url" max-height="100" max-width="100" alt="" />
                </router-link>
                <div class="d-flex flex-column flex-grow-1 flex-wrap pa-4 mw-0">
                  <div class="d-flex justify-space-between w-100 mb-3">
                    <div>
                      <div class="d-flex">
                        <h4 class="text-truncate mb-4">{{ item.title }}</h4>
                      </div>
                      <div>
                        <p class="grey--text text--darken-1 mb-0">
                          ¥{{ item.price }} x {{ item.cnt }}
                          <span class="brown--text text--darken-4 ms-2"
                            >¥{{ item.price * item.cnt }}</span
                          >
                        </p>
                      </div>
                      <div>
                        <p class="grey--text text--darken-1 mb-0">
                          {{ item.property }}
                        </p>
                      </div>
                    </div>
                    <v-btn icon @click="showDeleteDialog(item)">
                      <v-icon>mdi-close</v-icon>
                    </v-btn>
                  </div>
                  <div class="d-flex justify-end flex-grow-1 align-end">
                    <div class="d-flex align-center">
                      <v-btn
                        class="rounded"
                        outlined
                        fab
                        x-small
                        tile
                        color="brown lighten-1"
                        :disabled="item.isMinusDisable"
                        @click="decrement(item)">
                        <v-icon>mdi-minus</v-icon>
                      </v-btn>
                      <div class="text-center mx-2">{{ item.cnt }}</div>
                      <v-btn
                        class="rounded"
                        outlined
                        fab
                        x-small
                        tile
                        color="brown lighten-1"
                        :disabled="item.isPlusDisable"
                        @click="increment(item)">
                        <v-icon>mdi-plus</v-icon>
                      </v-btn>
                    </div>
                  </div>
                </div>
              </v-card>
            </div>
          </v-col>
          <v-col cols="4">
            <v-card v-if="products.length > 0">
              <div class="pa-5">
                <div class="d-flex justify-space-between">
                  <p class="mb-0 grey--text text--darken-1">Total</p>
                  <h4>¥{{ $store.getters["getTotalPrice"] + shippingFee }}</h4>
                </div>
                <v-divider class="my-3"></v-divider>
                <h4 class="mb-4">Shipping Estimates</h4>
                <p class="text-14 mb-1">Prefecture</p>
                <v-select
                  v-model="prefectureId"
                  dense
                  outlined
                  hide-details
                  color="brown lighten-1"
                  item-color="brown lighten-1"
                  class="mb-4"
                  :items="prefectures"
                  item-text="prefecture"
                  item-value="id"
                  label="Select Prefecture"></v-select>
                <v-btn
                  color="brown lighten-1"
                  outlined
                  class="text-capitalize mb-4"
                  block
                  @click="calShipping">
                  Calculate Shipping
                </v-btn>
                <div class="d-flex justify-space-between">
                  <p class="mb-4">Shipping Fee</p>
                  <h4>¥{{ shippingFee }}</h4>
                </div>
                <v-btn
                  v-if="!isAdmin"
                  dark
                  color="brown lighten-1"
                  class="text-capitalize mb-4"
                  block
                  @click="checkOut">
                  Checkout Now
                </v-btn>
              </div>
            </v-card>
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
  data() {
    return {
      products: [],
      itemToDelete: "",
      dialogDelete: false,
      countRules: [
        (v) => !!v || "This field is required",
        (v) => (v && v >= 0) || "count should be above 0",
        (v) => (v && v <= 10) || "Max should not be above 10",
      ],
      prefectures: [],
      prefectureId: null,
      shippingFee: 0,
    }
  },
  computed: {
    isAdmin: function () {
      return this.$auth && this.$auth.user && this.$auth.user.is_admin ? true : false
    },
  },
  created() {
    this.getProductList()
    this.loadPrefectures()
  },
  methods: {
    getProductList() {
      var cartItems = JSON.parse(localStorage.getItem("Cart"))
      if (cartItems.length == 0) {
        this.products = []
      } else {
        var hashids = []
        for (var i = 0; i < cartItems.length; i++) {
          hashids.push(cartItems[i].product_hashid)
        }
        this.$axios
          .get("api/cart/show_cart_products", {
            params: {
              hashids: hashids,
            },
          })
          .then((res) => {
            this.products = res.data.products
            // merge server cart to local cart
            for (var m = 0; m < this.products.length; m++) {
              for (var n = 0; n < cartItems.length; n++) {
                if (this.products[m].hashid == cartItems[n].product_hashid) {
                  this.products[m].cnt = cartItems[n].quantity
                  this.products[m].price = parseFloat(
                    this.products[m].price * (1 - this.products[m].discount)
                  ).toFixed(0)
                  // set button
                  this.products[m].isMinusDisable = this.isMinusDisable(this.products[m])
                  this.products[m].isPlusDisable = this.isPlusDisable(this.products[m])
                  break
                }
              }
            }
          })
      }
    },
    loadPrefectures() {
      this.$axios.get(`/api/prefectures`).then((res) => {
        this.prefectures = res.data
      })
    },
    isMinusDisable(item) {
      return item.cnt < 2 ? true : false
    },
    isPlusDisable(item) {
      return item.cnt == 10 || item.cnt == item.quantity ? true : false
    },
    showDeleteDialog(item) {
      this.itemToDelete = item
      this.dialogDelete = !this.dialogDelete
    },
    removeItem() {
      // remove from backend cart
      if (this.itemToDelete.cnt > 0) {
        if (this.$auth.loggedIn) {
          this.$axios
            .$post(`api/cart/remove_from_cart`, {
              product_id: this.itemToDelete.hashid,
              user_id: this.$auth.user.hashid,
            })
            .then((res) => {
              if (res.code === "error") {
                this.$toast.error(res.message)
              } else {
                this.$toast.show(res.message)
              }
            })
        }
      }
      this.dialogDelete = false
      this.$store.commit("remove_product_from_cart", this.itemToDelete.hashid)
      this.getProductList()
    },
    increment(item) {
      if (item.cnt == 10 || item.cnt == item.quantity) {
        // TODO button gray out
        return
      }
      if (this.$auth.loggedIn) {
        this.$axios
          .$post(`api/products/${item.hashid}/add_to_cart`, {
            product_id: item.hashid,
            user_id: this.$auth.user.hashid,
          })
          .then((res) => {
            if (res.code === "error") {
              this.$toast.error(res.message)
            } else {
              this.$toast.show(res.message)
            }
          })
      }
      // add to store
      var cartItem = new Object()
      cartItem.product_hashid = item.hashid
      cartItem.price = this.price
      this.$store.commit("add_product_to_cart", cartItem)
      this.getProductList()
    },
    decrement(item) {
      if (item.cnt < 2) {
        // TODO button gray out
        return
      }
      if (this.$auth.loggedIn) {
        this.$axios
          .$post(`api/products/${item.hashid}/decrease_of_cart`, {
            product_id: item.hashid,
            user_id: this.$auth.user.hashid,
          })
          .then((res) => {
            if (res.code === "error") {
              this.$toast.error(res.message)
            } else {
              this.$toast.show(res.message)
            }
          })
      }
      // decrease of store
      var cartItem = new Object()
      cartItem.product_hashid = item.hashid
      this.$store.commit("decrease_product_of_cart", cartItem)
      this.getProductList()
    },
    checkOut() {
      if (this.$auth.loggedIn) {
        if (!this.$store.getters["getCounter"]) {
          this.$toast.error("There are no items in the shopping cart")
        } else {
          this.$router.push(`/checkout`)
        }
      } else {
        this.$router.push(`/login`)
      }
    },
    calShipping() {
      if (this.prefectureId) {
        this.$axios.get(`/api/shipping_fees/${this.prefectureId}`).then((res) => {
          this.shippingFee = res.data.fee
        })
      } else {
        this.$toast.error("Please select prefecture")
      }
    },
  },
}
</script>
