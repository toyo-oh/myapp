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
              <v-col cols="12" class="py-0">
              </v-col>
              <v-col cols="12">
                <div class="pa-4 grey lighten-3 align-center d-flex justify-space-between">
                  <div class="flex-1 mr-3 pl-2">
                    <v-avatar tile size="32">
                      <v-icon>mdi-home</v-icon>
                    </v-avatar>
                    <p>{{display_address}}</p>
                  </div>
                  <div class="flex-1 mr-3">
                    <v-dialog v-model="addressDialog" scrollable max-width="500px">
                      <template v-slot:activator="{ on, attrs }">
                        <v-btn icon color="brown" class="" v-bind="attrs" v-on="on" @click="getAddressList">
                          <v-icon>mdi-arrow-right</v-icon>
                        </v-btn>
                      </template>
                      <v-card>
                        <v-card-title>Select Address</v-card-title>
                        <v-divider></v-divider>
                        <v-card-text style="height: 300px;">
                          <v-radio-group v-model="selectedAddressId" column>
                            <v-radio v-for="(item, index) in addressList" color="brown lighten-1" :key="index" :label='item.receiver + " " + item.phone_number
          + " " + item.post_code + " " + item.detail_address' :value="item.id"></v-radio>
                          </v-radio-group>
                        </v-card-text>
                        <v-divider></v-divider>
                        <v-card-actions>
                          <v-btn color="brown lighten-1" text @click="addressDialog = false">CLOSE</v-btn>
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
              <v-col cols="12" xl="4" lg="4">
                <div class="pa-4 grey lighten-3 br-8 d-flex justify-space-between">
                  <div class="flex-1 mr-3">
                    <v-avatar tile size="32">
                      <v-icon>mdi-credit-card</v-icon>
                    </v-avatar>
                    <p class="mb-0">**** **** **** {{paymentCardNumber}}</p>
                    <p class="mb-0">{{paymentHolderName}}</p>
                  </div>
                  <div class="flex-1 mt-5 mr-0">
                    <v-dialog v-model="paymentDialog" scrollable max-width="500px">
                      <template v-slot:activator="{ on, attrs }">
                        <v-btn icon color="brown" class="" v-bind="attrs" v-on="on" @click="getPaymentList">
                          <v-icon>mdi-arrow-right</v-icon>
                        </v-btn>
                      </template>
                      <v-card>
                        <v-card-title>Select Payment</v-card-title>
                        <v-divider></v-divider>
                        <v-card-text style="height: 300px;">
                          <v-radio-group v-model="selectedPaymentId" column>
                            <v-radio v-for="(item, index) in paymentList" color="brown lighten-1" :key="index" :label='item.holder_name + " **** **** **** " + item.card_number.substring(12,16)+ " " + item.expiration_date' :value="item.id"></v-radio>
                          </v-radio-group>
                        </v-card-text>
                        <v-divider></v-divider>
                        <v-card-actions>
                          <v-btn color="brown lighten-1" text @click="paymentDialog = false">CLOSE</v-btn>
                          <v-btn color="brown lighten-1" text @click="choosePayment">OK</v-btn>
                        </v-card-actions>
                      </v-card>
                    </v-dialog>
                  </div>
                </div>

              </v-col>
              <v-col cols="12" class="py-0">
                <v-btn dark color="brown lighten-1" class="text-capitalize mb-4" block @click="createOrder">
                  Place Order
                </v-btn>
              </v-col>
            </v-row>
          </div>
        </v-card>
      </v-col>
      <v-col cols="12" md="6" lg="4" xl="4">
        <p class="font-weight-bold mb-6">You Order</p>
        <div v-for="item in products" :key="item.id" class="d-flex justify-space-between mb-6">
          <p class="mb-0"><span class="font-weight-bold">{{item.cnt}}</span> x {{item.title}}</p>
          <p class="mb-0">¥{{item.price * item.cnt}}</p>
        </div>
        <v-divider class="my-4"></v-divider>
        <div class="d-flex justify-space-between mb-2">
          <p class="mb-0 grey--text text--darken-2">Subtotal:</p>
          <p class="mb-0 font-weight-bold">¥{{$store.getters['getTotalPrice']}}</p>
        </div>
        <div class="d-flex justify-space-between mb-2">
          <p class="mb-0 grey--text text--darken-2">Shipping:</p>
          <p class="mb-0 font-weight-bold">¥{{shippingFee}}</p>
        </div>
        <div class="d-flex justify-space-between mb-2">
          <p class="mb-0 grey--text text--darken-2">Discount:</p>
          <p class="mb-0 font-weight-bold"> - </p>
        </div>
        <v-divider class="my-4"></v-divider>
        <div class="d-flex justify-space-between mb-2">
          <p class="mb-0 font-weight-bold">Total:</p>
          <p class="mb-0 font-weight-bold"> ¥{{$store.getters['getTotalPrice']+ this.shippingFee}}</p>
        </div>
      </v-col>
    </v-row>
  </div>
</template>

<script>
export default {
  middleware: 'auth',
  data () {
    return {
      products: [],
      totalPrice: '',
      addressId: '',
      addressDetail: '',
      addressDialog: false,
      addressList: [],
      selectedAddressId: '',
      paymentId: '',
      paymentHolderName: '',
      paymentCardNumber: '',
      paymentDialog: false,
      paymentList: [],
      selectedPaymentId: '',
      shippingFee: 0
    };
  },
  created () {
    this.loadData();
  },
  computed: {
    display_address: function () {
      return this.addressDetail;
    }
  },
  methods: {
    loadData () {
      this.$axios.get(`api/cart/get_checkout_info/${this.$auth.user.id}`).then((res) => {
        var cartItems = res.data.cart_items;
        for (var m = 0; m < cartItems.length; m++) {
          var product = {};
          product.title = cartItems[m].product.title;
          product.price = cartItems[m].price;
          product.cnt = cartItems[m].quantity;
          // TODO baseURL
          product.image = "http://localhost:3000" + cartItems[m].product.images[0].thumb.url;
          // this.products[m].image = this.$axios.baseURL + this.products[m].image.thumb.url;
          this.products.push(product);
        }
        if (res.data.address.length > 0) {
          var default_address = res.data.address[0];
          this.addressDetail = default_address.receiver + " " + default_address.phone_number
            + " " + default_address.post_code + " " + default_address.detail_address;
          this.addressId = default_address.id;
        }
        if (res.data.payment.length > 0) {
          this.paymentId = res.data.payment[0].id;
          this.paymentHolderName = res.data.payment[0].holder_name;
          this.paymentCardNumber = res.data.payment[0].card_number.substring(12, 16);
        }
        this.getShipping();
      });
    },
    getShipping () {
      if (this.addressId) {
        this.$axios.get(`api/addresses/get_shipping_fee/${this.addressId}`).then((res) => {
          this.shippingFee = res.data.fee
        });
      }
    },
    getAddressList () {
      this.$axios.get(`api/addresses/find_by_user_id/${this.$auth.user.id}`).then((res) => {
        this.addressList = res.data;
      });
    },
    chooseAddress () {
      this.addressDialog = false;
      for (var m = 0; m < this.addressList.length; m++) {
        if (this.addressList[m].id == this.selectedAddressId) {
          this.addressDetail = this.addressList[m].receiver + " " + this.addressList[m].phone_number
            + " " + this.addressList[m].post_code + " " + this.addressList[m].detail_address;
          this.addressId = this.selectedAddressId;
          break;
        }
      }
      this.getShipping();
    },
    getPaymentList () {
      this.$axios.get(`api/payments/find_by_user_id/${this.$auth.user.id}`).then((res) => {
        this.paymentList = res.data;
      });
    },
    choosePayment () {
      this.paymentDialog = false;
      for (var m = 0; m < this.paymentList.length; m++) {
        if (this.paymentList[m].id == this.selectedPaymentId) {
          this.paymentHolderName = this.paymentList[m].holder_name;
          this.paymentCardNumber = this.paymentList[m].card_number.substring(12, 16);
          this.paymentId = this.selectedPaymentId;
          break;
        }
      }
    },
    createOrder () {
      if (!this.$auth.user.id) {
        this.$router.push(`/login`)
      } else if (!this.addressId) {
        this.$toast.error('Please select Delivery Address!');
      } else if (!this.paymentId) {
        this.$toast.error('Please select Payment Method!');
      } else {
        const formData = new FormData();
        formData.append("user_id", this.$auth.user.id);
        formData.append("address_id", this.addressId);
        formData.append("payment_id", this.paymentId);
        formData.append("shipping_fee", this.shippingFee);
        this.$axios.post("/api/order/create_order", formData).then((res) => {
          this.$router.push(`/orders/${res.data.order_id}`);
          this.$store.commit('clear_cart');
          this.$toast.show('Create order successfully!');
        });
      }
    }
  },
};
</script>