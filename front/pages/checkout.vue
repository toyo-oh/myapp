<template>
  <div>
    <v-row>
      <v-col cols="12" md="6" lg="8" xl="8">
        <v-card class="mb-4">
          <div class="pa-4">
            <v-row>
              <v-col cols="12">
                <div class="d-flex">
                  <v-avatar size="30" color="brown lighten-1" class="me-3">
                    <p class="white--text mb-0">1</p>
                  </v-avatar>
                  <h3 class="font-weight-light">Delivery Address</h3>
                </div>
              </v-col>
              <v-col cols="12" class="py-0"> </v-col>
              <v-col cols="12">
                <div class="pa-4 grey lighten-3 align-center d-flex justify-space-between">
                  <div class="flex-1 mr-3 pl-2">
                    <v-avatar tile size="32">
                      <v-icon>mdi-home</v-icon>
                    </v-avatar>
                    <p>{{ display_address }}</p>
                  </div>
                  <div class="flex-1 mr-3">
                    <v-dialog v-model="addressDialog" scrollable max-width="500px">
                      <template #activator="{ on, attrs }">
                        <v-btn
                          icon
                          color="brown"
                          class=""
                          v-bind="attrs"
                          v-on="on"
                          @click="getAddressList">
                          <v-icon>mdi-arrow-right</v-icon>
                        </v-btn>
                      </template>
                      <v-card>
                        <v-card-title>Select Address</v-card-title>
                        <v-divider></v-divider>
                        <v-card-text style="height: 300px">
                          <v-radio-group v-model="selectedAddressId" column>
                            <v-radio
                              v-for="(item, index) in addressList"
                              :key="index"
                              color="brown lighten-1"
                              :label="item.label"
                              :value="item.hashid">
                            </v-radio>
                          </v-radio-group>
                        </v-card-text>
                        <v-divider></v-divider>
                        <v-card-actions>
                          <v-btn color="brown lighten-1" text @click="addressDialog = false"
                            >CLOSE</v-btn
                          >
                          <v-btn color="brown lighten-1" text @click="chooseAddress">OK</v-btn>
                        </v-card-actions>
                      </v-card>
                    </v-dialog>
                  </div>
                </div>
              </v-col>
            </v-row>
          </div>
        </v-card>
        <v-card class="mb-4">
          <div class="pa-4">
            <v-row>
              <v-col cols="12">
                <div class="d-flex">
                  <v-avatar size="30" color="brown lighten-1" class="me-3">
                    <p class="white--text mb-0">2</p>
                  </v-avatar>
                  <h3 class="font-weight-light">Payment Methods</h3>
                </div>
              </v-col>
              <v-col cols="12">
                <div class="pa-4 lighten-3 br-8">
                  <stripe-element-card
                    ref="elementRef"
                    :hide-postal-code="hidePostalCode"
                    :pk="publishableKey"
                    @token="tokenCreated" />
                </div>
              </v-col>
              <!-- <v-col cols="12" class="py-0">
                <v-btn id="custom-button" dark color="brown lighten-1" class="text-capitalize mb-4" block @click="submit">Place Order</v-btn>
              </v-col> -->
            </v-row>
          </div>
        </v-card>
      </v-col>
      <v-col cols="12" md="6" lg="4" xl="4">
        <v-card>
          <div class="pa-5">
            <p class="font-weight-bold mb-6">You Order</p>
            <div
              v-for="item in products"
              :key="item.hashid"
              class="d-flex justify-space-between mb-6">
              <p class="mb-0">
                <span class="font-weight-bold">{{ item.cnt }}</span> x
                {{ item.title }}
              </p>
              <p class="mb-0">¥{{ item.price * item.cnt }}</p>
            </div>
            <v-divider class="my-4"></v-divider>
            <div class="d-flex justify-space-between mb-2">
              <p class="mb-0 grey--text text--darken-2">Subtotal:</p>
              <p class="mb-0 font-weight-bold">¥{{ $store.getters["getTotalPrice"] }}</p>
            </div>
            <div class="d-flex justify-space-between mb-2">
              <p class="mb-0 grey--text text--darken-2">Shipping:</p>
              <p class="mb-0 font-weight-bold">¥{{ shippingFee }}</p>
            </div>
            <div class="d-flex justify-space-between mb-2">
              <p class="mb-0 grey--text text--darken-2">Discount:</p>
              <p class="mb-0 font-weight-bold">-</p>
            </div>
            <v-divider class="my-4"></v-divider>
            <div class="d-flex justify-space-between mb-4">
              <p class="mb-0 font-weight-bold">Total:</p>
              <p class="mb-0 font-weight-bold">
                ¥{{ $store.getters["getTotalPrice"] + shippingFee }}
              </p>
            </div>
            <v-btn
              id="custom-button"
              dark
              color="brown lighten-1"
              class="text-capitalize mb-4"
              block
              @click="submit"
              >Place Order</v-btn
            >
          </div>
        </v-card>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import { StripeElementCard } from "@vue-stripe/vue-stripe"
export default {
  components: {
    StripeElementCard,
  },
  middleware: "auth",
  data() {
    this.publishableKey = process.env.STRIPE_PK
    return {
      products: [],
      totalPrice: "",
      addressId: "",
      addressDetail: "",
      addressDialog: false,
      addressList: [],
      selectedAddressId: "",
      selectedPaymentId: "",
      shippingFee: 0,
      token: null,
      hidePostalCode: true,
    }
  },
  computed: {
    display_address: function () {
      return this.addressDetail
    },
  },
  created() {
    this.loadData()
  },
  methods: {
    submit() {
      this.$refs.elementRef.submit()
    },
    tokenCreated(token) {
      // send it to your server
      this.createOrder(token.id)
    },
    loadData() {
      this.$axios.get(`api/cart/find_checkout_info/${this.$auth.user.hashid}`).then((res) => {
        if (res.data.code === "error") {
          this.$toast.error(res.data.message)
        } else {
          var cartItems = res.data.cart_items
          for (var m = 0; m < cartItems.length; m++) {
            var product = {}
            product.title = cartItems[m].product.title
            product.price = cartItems[m].price
            product.cnt = cartItems[m].quantity
            // TODO baseURL
            product.image = "http://localhost:3000" + cartItems[m].product.images[0].thumb.url
            // this.products[m].image = this.$axios.baseURL + this.products[m].image.thumb.url;
            this.products.push(product)
          }
          var default_address = res.data.address
          this.addressId = default_address.hashid
          this.addressDetail =
            default_address.receiver +
            " " +
            default_address.phone_number +
            " " +
            default_address.post_code +
            " " +
            default_address.detail_address
          this.getShipping()
        }
      })
    },
    getShipping() {
      if (this.addressId) {
        this.$axios.get(`api/addresses/find_shipping_fee/${this.addressId}`).then((res) => {
          this.shippingFee = res.data.fee
        })
      }
    },
    getAddressList() {
      this.$axios.get(`api/addresses/find_by_user_id/${this.$auth.user.hashid}`).then((res) => {
        this.addressList = res.data.addresses
        for (var i = 0; i < this.addressList.length; i++) {
          this.addressList[i].label =
            this.addressList[i].receiver +
            " " +
            this.addressList[i].phone_number +
            " " +
            this.addressList[i].post_code +
            " " +
            this.addressList[i].detail_address
        }
      })
    },
    chooseAddress() {
      this.addressDialog = false
      for (var m = 0; m < this.addressList.length; m++) {
        if (this.addressList[m].hashid == this.selectedAddressId) {
          this.addressDetail =
            this.addressList[m].receiver +
            " " +
            this.addressList[m].phone_number +
            " " +
            this.addressList[m].post_code +
            " " +
            this.addressList[m].detail_address
          this.addressId = this.selectedAddressId
          break
        }
      }
      this.getShipping()
    },
    createOrder(token_id) {
      if (!this.$auth.loggedIn) {
        this.$router.push(`/login`)
      } else if (!this.addressId) {
        this.$toast.error("Please select Delivery Address!")
      } else {
        const formData = new FormData()
        formData.append("user_id", this.$auth.user.hashid)
        formData.append("address_id", this.addressId)
        formData.append("shipping_fee", this.shippingFee)
        formData.append("stripe_token", token_id)
        this.$axios.post("/api/order/create_order", formData).then((res) => {
          if (res.data.code == "error") {
            this.$toast.error(res.data.message)
          } else {
            this.$router.push(`/orders/${res.data.order_no}`)
            this.$store.commit("clear_cart")
            this.$toast.show(res.data.message)
          }
        })
      }
    },
  },
}
</script>
