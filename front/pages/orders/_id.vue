<template>
  <div>
    <v-row>
      <v-col cols="12">
        <div class="box-wrapper">
          <div class="box-content">
            <div class="box-container">
              <div class="d-flex justify-space-between flex-wrap mb-5">
                <div class="d-flex align-center ">
                  <v-avatar tile size="25" class="me-3">
                    <v-icon>mdi-shopping</v-icon>
                  </v-avatar>
                  <h2 class="mb-0">Order Details</h2>
                </div>
                <div>
                  <v-btn outlined color="brown lighten-1" class="text-capitalize" @click="rtnToList">
                    Back To Order List
                  </v-btn>
                </div>
              </div>
              <v-row>
                <v-col cols="12">
                  <v-card>
                    <div class="px-6 pt-8 pb-8">
                      <div class="d-flex justify-start mb-10">
                        <div class="py-2 px-5 brown lighten-4 brown--text text-center text-wrap rounded-pill">
                          <p class="mb-0">
                            Order Status:
                            <span class="font-weight-bold">{{orderStatus}}</span>
                          </p>
                        </div>
                      </div>
                      <div class="d-flex align-center" v-if="orderStatus=='order_cancelled'">
                        <div class="p-relative">
                          <v-avatar size="72" color="brown lighten-2">
                            <v-badge color="green lighten-1" icon="mdi-check">
                              <v-icon color="grey lighten-4">mdi-cube-outline</v-icon>
                            </v-badge>
                          </v-avatar>
                        </div>
                        <v-sheet color="brown lighten-1" elevation="0" height="4" class="flex-grow-1" v-if="isPaid"></v-sheet>
                        <div v-if="isPaid">
                          <v-avatar size="72" color="brown lighten-2">
                            <v-badge color="green lighten-1" icon="mdi-check">
                              <v-icon color="grey lighten-4">mdi-briefcase-variant-outline</v-icon>
                            </v-badge>
                          </v-avatar>
                        </div>
                        <v-sheet color="brown lighten-1" elevation="0" height="4" class="flex-grow-1"></v-sheet>
                        <div>
                          <v-avatar size="72" color="brown lighten-2">
                            <v-badge color="green lighten-1" icon="mdi-check">
                              <v-icon color="grey lighten-4">mdi-cancel</v-icon>
                            </v-badge>
                          </v-avatar>
                        </div>
                      </div>
                      <div class="d-flex align-center" v-else>
                        <div class="p-relative">
                          <v-avatar size="72" color="brown lighten-2">
                            <v-badge color="green lighten-1" icon="mdi-check">
                              <v-icon color="grey lighten-4">mdi-cube-outline</v-icon>
                            </v-badge>
                          </v-avatar>
                        </div>
                        <v-sheet :color="(orderStatus=='paid' || orderStatus=='shipping' || orderStatus=='shipped') ? 'brown lighten-1' : 'grey lighten-2'" elevation="0" height="4" class="flex-grow-1"></v-sheet>
                        <div>
                          <template v-if="(orderStatus=='paid' || orderStatus=='shipping' || orderStatus=='shipped')">
                            <v-avatar size="72" color="brown lighten-2">
                              <v-badge color="green lighten-1" icon="mdi-check">
                                <v-icon color="grey lighten-4">mdi-briefcase-variant-outline</v-icon>
                              </v-badge>
                            </v-avatar>
                          </template>
                          <template v-else>
                            <v-avatar size="72" color="brown lighten-2">
                              <v-icon color="grey lighten-4">mdi-briefcase-variant-outline</v-icon>
                            </v-avatar>
                          </template>
                        </div>
                        <v-sheet :color="(orderStatus=='shipping' || orderStatus=='shipped') ? 'brown lighten-1' : 'grey lighten-2'" elevation="0" height="4" class="flex-grow-1"></v-sheet>
                        <div>
                          <template v-if="(orderStatus=='shipping' || orderStatus=='shipped') ">
                            <v-avatar size="72" color="brown lighten-2">
                              <v-badge color="green lighten-1" icon="mdi-check">
                                <v-icon color="grey lighten-4">mdi-car-pickup</v-icon>
                              </v-badge>
                            </v-avatar>
                          </template>
                          <template v-else>
                            <v-avatar size="72" color="brown lighten-2">
                              <v-icon color="grey lighten-4">mdi-car-pickup</v-icon>
                            </v-avatar>
                          </template>
                        </div>
                        <v-sheet :color="orderStatus=='shipped' ? 'brown lighten-1' : 'grey lighten-2'" elevation="0" height="4" class="flex-grow-1"></v-sheet>
                        <div>
                          <template v-if="(orderStatus=='shipped')">
                            <v-avatar size="72" color="brown lighten-2">
                              <v-badge color="green lighten-1" icon="mdi-check">
                                <v-icon color="grey lighten-4">mdi-check-circle-outline</v-icon>
                              </v-badge>
                            </v-avatar>
                          </template>
                          <template v-else>
                            <v-avatar size="72" color="brown lighten-2">
                              <v-icon color="grey lighten-4">mdi-check-circle-outline</v-icon>
                            </v-avatar>
                          </template>
                        </div>
                      </div>
                      <div class="d-flex justify-end mt-10">
                        <div>
                          <v-btn v-if="display_pay_btn" dark color="brown lighten-1" class="text-capitalize" @click="payOrder">
                            Pay Order
                          </v-btn>
                          <v-btn v-if="display_cancel_btn" dark color="brown lighten-1" class="text-capitalize" @click="showCancelDialog()">
                            Cancel Order
                          </v-btn>
                          <v-btn v-if="display_receive_btn" dark color="brown lighten-1" class="text-capitalize" @click="receiveGoods">
                            Receive goods
                          </v-btn>
                        </div>
                      </div>
                    </div>
                  </v-card>
                </v-col>
                <v-col cols="12">
                  <v-card>
                    <div class="grey lighten-2 d-flex justify-space-around flex-wrap">
                      <div class="d-flex my-3 mx-3">
                        <p class="text-14 grey--text text--darken-2 mb-0 mr-2">
                          Order ID:
                        </p>
                        <p class="mb-0 grey--text text--darken-4">
                          {{orderId}}
                        </p>
                      </div>
                      <div class="d-flex my-3 mx-3">
                        <p class="text-14 grey--text text--darken-2 mb-0 mr-2">
                          Placed on:
                        </p>
                        <p class="mb-0 grey--text text--darken-4">
                          {{ new Date(placedOn).toLocaleString("ja-jp") }}
                        </p>
                      </div>
                      <div class="d-flex my-3 mx-3">
                        <p class="text-14 grey--text text--darken-2 mb-0 mr-2">
                          Delivered on:
                        </p>
                        <p class="mb-0 grey--text text--darken-4">
                          {{ deliverOn ? new Date(deliverOn).toLocaleString("ja-jp") :'ー' }}
                        </p>
                      </div>
                    </div>
                    <div v-for="item in products" :key="item.id">
                      <div class="d-flex align-center justify-space-around flex-wrap  pa-4">
                        <div class="d-flex align-center flex-wrap me-4">
                          <router-link :to="{name: 'products-id', params: {id: item.id}}">
                            <v-avatar tile size="64" class="me-4">
                              <img :src="item.image" max-height="100" max-width="100">
                            </v-avatar>
                          </router-link>
                          <div class="">
                            <div class="text-14">
                              {{ item.title }}
                            </div>
                            <div class="text-14 grey--text text--darken-2">
                              ¥{{ item.price }} x {{ item.cnt }}
                            </div>
                          </div>
                        </div>
                        <p class="mb-0 grey--text text--darken-2">
                          Product properties: TODO
                        </p>
                        <v-dialog v-model="reviewDialog" max-width="500px">
                          <template v-slot:activator="{ on, attrs }">
                            <v-btn text color="brown lighten-1" class="text-capitalize font-weight-bold" v-bind="attrs" v-on="on">Write a Review</v-btn>
                          </template>
                          <v-card>
                            <v-card-title>Write a Review for this product</v-card-title>
                            <v-divider></v-divider>
                            <v-card-text style="height: 300px;">
                              <br>
                              <h5 class="mb-3">Your Rating <sup class="brown--text">*</sup></h5>
                              <v-rating v-model="rate" color="amber" background-color="grey lighten-2" class="mb-3" dense half-increments size="20"></v-rating>
                              <h5 class="mb-3">Your Review <sup class="brown--text">*</sup></h5>
                              <v-textarea v-model="comment" color="brown lighten-1" class="mb-3" outlined background-color="white">
                              </v-textarea>
                            </v-card-text>
                            <v-divider></v-divider>
                            <v-card-actions>
                              <v-btn color="brown lighten-1" text @click="reviewProduct(item)">Submit</v-btn>
                              <v-btn color="brown lighten-1" text @click="reviewDialog = false">Cancel</v-btn>
                            </v-card-actions>
                          </v-card>
                        </v-dialog>
                      </div>
                    </div>
                  </v-card>
                </v-col>
                <v-col cols="12" lg="6">
                  <v-card>
                    <div class="pa-5">
                      <h4 class="mb-3 grey--text text--darken-4">
                        Shipping Address
                      </h4>
                      <p class="text-14 mb-0">
                        {{addressDetail}}
                      </p>
                    </div>
                  </v-card>
                  <v-card>
                    <div class="pa-5 mt-5">
                      <h4 class="mb-3 grey--text text--darken-4">
                        Payment Details
                      </h4>
                      <p class="text-14 mb-0">
                        {{paymentDetail}}
                      </p>
                    </div>
                  </v-card>
                </v-col>
                <v-col cols="12" lg="6">
                  <v-card>
                    <div class="pa-5">
                      <h4 class="mb-3 grey--text text--darken-4">
                        Total Summary
                      </h4>
                      <div class="d-flex justify-space-between mb-2">
                        <p class="tex-14 mb-0 grey--text text--darken-2">
                          Subtotal:
                        </p>
                        <p class="tex-14 mb-0 font-weight-bold">
                          ¥{{totalPrice}}
                        </p>
                      </div>
                      <div class="d-flex justify-space-between mb-2">
                        <p class="tex-14 mb-0 grey--text text--darken-2">
                          Shipping fee:
                        </p>
                        <p class="tex-14 mb-0 font-weight-bold">
                          ¥{{shippingFee}}
                        </p>
                      </div>
                      <div class="d-flex justify-space-between mb-2">
                        <p class="tex-14 mb-0 grey--text text--darken-2">
                          Discount:
                        </p>
                        <p class="tex-14 mb-0 font-weight-bold">
                          -
                        </p>
                      </div>
                      <v-divider class="my-3"></v-divider>
                      <div class="d-flex justify-space-between mb-2">
                        <p class="tex-14 mb-0 font-weight-bold">
                          Total:
                        </p>
                        <p class="tex-14 mb-0 font-weight-bold">
                          ¥{{totalPrice+shippingFee}}
                        </p>
                      </div>
                    </div>
                  </v-card>
                </v-col>
              </v-row>
            </div>
          </div>
          <v-dialog v-model="dialogCancel" max-width="200px">
            <v-card>
              <v-card-title>Cancel</v-card-title>
              <v-card-text>Are you sure to cancel the order?</v-card-text>
              <v-spacer></v-spacer>
              <v-card-actions>
                <v-btn color="brown lighten-1" text @click="cancelOrder()">OK</v-btn>
                <v-btn color="brown lighten-1" text @click="dialogCancel = false">Cancel</v-btn>
              </v-card-actions>
            </v-card>
          </v-dialog>
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
      totalPrice: 0,
      shippingFee: 0,
      orderId: '',
      addressDetail: '',
      paymentDetail: '',
      reviewDialog: false,
      dialogCancel: false,
      orderStatus: '',
      isPaid: false,
      placedOn: '',
      deliverOn: '',
      comment: '',
      rate: 0
    };
  },
  computed: {
    display_cancel_btn: function () {
      return this.orderStatus == 'order_placed' || this.orderStatus == 'paid' ? true : false
    },
    display_pay_btn: function () {
      return this.orderStatus == 'order_placed' ? true : false
    },
    display_order_status: function () {
      return this.orderStatus;
    },
    display_receive_btn: function () {
      return this.orderStatus == 'shipping' ? true : false
    }
  },
  created () {
    this.loadOrder();
  },
  methods: {
    loadOrder () {
      this.$axios.get(`api/orders/${this.$route.params.id}`).then((res) => {
        var orderItems = res.data.order_details;
        var tmpProducts = [];
        var tmpTotal = 0;
        for (var m = 0; m < orderItems.length; m++) {
          var product = {};
          product.id = orderItems[m].product_id;
          product.title = orderItems[m].product_title;
          product.price = orderItems[m].price;
          product.cnt = orderItems[m].quantity;
          product.image = "http://localhost:3000" + orderItems[m].product.images[0].thumb.url;
          tmpProducts.push(product);
          tmpTotal += orderItems[m].subtotal;
        }
        this.addressDetail = res.data.address.receiver + " " + res.data.address.phone_number
          + " " + res.data.address.post_code + " " + res.data.address.detail_address;
        this.paymentDetail = res.data.payment.holder_name + " **** **** **** " + res.data.payment.card_number.substring(12, 16);
        this.products = tmpProducts;
        this.totalPrice = tmpTotal;
        this.orderId = res.data.order.id;
        this.orderStatus = res.data.order.aasm_state;
        this.shippingFee = res.data.order.shipping_fee == null ? 0 : res.data.order.shipping_fee;
        this.isPaid = res.data.order.is_paid == '1' ? true : false;
        this.placedOn = res.data.order.created_at;
        this.deliverOn = res.data.order.deliver_at ? res.data.order.deliver_at : '';
      }).catch((err) => {
        if (err.response && err.response.status === 401) {
          this.$router.push('/orders');
          this.$toast.error('Unauthorized!');
        }
      });
    },
    payOrder () {
      if (!this.$auth.loggedIn) {
        this.$toast.error('Please login in before pay the order!');
      } else {
        this.$axios.post(`/api/orders/pay_order`, { id: this.orderId }).then((res) => {
          this.orderStatus = res.data.aasm_state;
          this.$toast.show('Order paid successfully!');
        });
      }
    },
    showCancelDialog () {
      this.dialogCancel = !this.dialogCancel
    },
    cancelOrder () {
      if (!this.$auth.loggedIn) {
        this.$toast.error('Please login in before cancel the order!');
      } else {
        this.$axios.delete(`api/orders/${this.orderId}`).then((res) => {
          this.orderStatus = res.data.aasm_state;
          this.dialogCancel = false;
          this.$toast.show('Cancel order successfully!');
        });
      }
    },
    receiveGoods () {
      if (!this.$auth.loggedIn) {
        this.$toast.error('Please login in before receive the order!');
      } else {
        this.$axios.post(`api/orders/receive_good`, { id: this.orderId }).then((res) => {
          this.$toast.show('Receive order successfully!');
          this.orderStatus = res.data.aasm_state;
        });
      }
    },
    rtnToList () {
      this.$router.push(`.`);
    },
    reviewProduct (item) {
      this.reviewDialog = false;
      if (this.$auth.loggedIn) {
        this.$axios.$post('api/reviews', {
          product_id: item.id,
          user_id: this.$auth.user.id,
          comment: this.comment,
          rate: this.rate
        }).then(() => {
          this.$toast.show('Review the product successfully!');
          this.rate = 0;
          this.comment = "";
        });
      } else {
        this.$toast.error('Please login in before review the product!');
      }
    }
  },
};
</script>

<style lang="postcss" scoped>
.w-32 {
  width: 32px;
}
.w-12 {
  width: 12px;
}
.order-details-custom-done {
  position: absolute;
  top: 0;
  right: 0;
  z-index: 1;
}
</style>