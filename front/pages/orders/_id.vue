<template>
  <div>
    <v-alert v-model="alertCancel" type="success" close-text="Close Alert" dismissible>
      Order cancelled successfully！
    </v-alert>
    <v-alert v-model="alertPay" type="success" close-text="Close Alert" dismissible>
      Order paid successfully！
    </v-alert>
    <v-alert v-model="alertReceive" type="success" close-text="Close Alert" dismissible>
      Order completed！
    </v-alert>
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
                  <base-card>
                    <div class="px-6 pt-8 pb-8">
                      <div class="d-flex justify-start mb-10">
                        <div class="py-2 px-5 brown lighten-4 brown--text text-center text-wrap rounded-pill">
                          <p class="mb-0">
                            Order Status:
                            <span class="font-weight-bold">{{order_status}}</span>
                          </p>
                        </div>
                      </div>
                      <div class="d-flex align-center" v-if="order_status=='order_cancelled'">
                        <div class="p-relative">
                          <v-avatar size="72" color="brown lighten-2">
                            <v-badge color="green lighten-1" icon="mdi-check">
                              <v-icon color="grey lighten-4">mdi-cube-outline</v-icon>
                            </v-badge>
                          </v-avatar>
                        </div>
                        <v-sheet color="brown lighten-1" elevation="0" height="4" class="flex-grow-1" v-if="is_paid"></v-sheet>
                        <div v-if="is_paid">
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
                        <v-sheet :color="(order_status=='paid' || order_status=='shipping' || order_status=='shipped') ? 'brown lighten-1' : 'grey lighten-2'" elevation="0" height="4" class="flex-grow-1"></v-sheet>
                        <div>
                          <template v-if="(order_status=='paid' || order_status=='shipping' || order_status=='shipped')">
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
                        <v-sheet :color="(order_status=='shipping' || order_status=='shipped') ? 'brown lighten-1' : 'grey lighten-2'" elevation="0" height="4" class="flex-grow-1"></v-sheet>
                        <div>
                          <template v-if="(order_status=='shipping' || order_status=='shipped') ">
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
                        <v-sheet :color="order_status=='shipped' ? 'brown lighten-1' : 'grey lighten-2'" elevation="0" height="4" class="flex-grow-1"></v-sheet>
                        <div>
                          <template v-if="(order_status=='shipped')">
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
                  </base-card>
                </v-col>
                <v-col cols="12">
                  <base-card>
                    <div class="grey lighten-2 d-flex justify-space-around flex-wrap">
                      <div class="d-flex my-3 mx-3">
                        <p class="text-14 grey--text text--darken-2 mb-0 mr-2">
                          Order ID:
                        </p>
                        <p class="mb-0 grey--text text--darken-4">
                          {{order_id}}
                        </p>
                      </div>
                      <div class="d-flex my-3 mx-3">
                        <p class="text-14 grey--text text--darken-2 mb-0 mr-2">
                          Placed on:
                        </p>
                        <p class="mb-0 grey--text text--darken-4">
                          {{ new Date(placed_on).toLocaleString("ja-jp") }}
                        </p>
                      </div>
                      <div class="d-flex my-3 mx-3">
                        <p class="text-14 grey--text text--darken-2 mb-0 mr-2">
                          Delivered on:
                        </p>
                        <p class="mb-0 grey--text text--darken-4">
                          {{ deliver_on ? new Date(deliver_on).toLocaleString("ja-jp") :'ー' }}
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
                          Product properties: Black, L
                        </p>
                        <v-btn text color="brown lighten-1" class="text-capitalize font-weight-bold">Write a Review</v-btn>
                      </div>
                    </div>
                  </base-card>
                </v-col>
                <v-col cols="12" lg="6">
                  <base-card>
                    <div class="pa-5">
                      <h4 class="mb-3 grey--text text--darken-4">
                        Shipping Address
                      </h4>
                      <p class="text-14 mb-0">
                        {{address_detail}}
                      </p>
                    </div>
                  </base-card>
                  <base-card>
                    <div class="pa-5 mt-5">
                      <h4 class="mb-3 grey--text text--darken-4">
                        Payment Details
                      </h4>
                      <p class="text-14 mb-0">
                        {{payment_detail}}
                      </p>
                    </div>
                  </base-card>
                </v-col>
                <v-col cols="12" lg="6">
                  <base-card>
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
                          ¥{{shipping_fee}}
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
                          ¥{{totalPrice+shipping_fee}}
                        </p>
                      </div>
                    </div>
                  </base-card>
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
      shipping_fee: 0,
      order_id: '',
      address_detail: '',
      payment_detail: '',
      dialogCancel: false,
      alertCancel: false,
      alertPay: false,
      alertReceive: false,
      order_status: '',
      is_paid: false,
      placed_on: '',
      deliver_on: ''
    };
  },
  computed: {
    display_cancel_btn: function () {
      return this.order_status == 'order_placed' || this.order_status == 'paid' ? true : false
    },
    display_pay_btn: function () {
      return this.order_status == 'order_placed' ? true : false
    },
    display_order_status: function () {
      return this.order_status;
    },
    display_receive_btn: function () {
      return this.order_status == 'shipping' ? true : false
    }
  },
  asyncData ({ $axios, params }) {
    return $axios.get(`api/orders/${params.id}`).then((res) => {
      var order_items = res.data.order_details;
      var tmp_products = [];
      var tmp_total = 0;
      for (var m = 0; m < order_items.length; m++) {
        var product = {};
        product.id = order_items[m].product_id;
        product.title = order_items[m].product_title;
        product.price = order_items[m].price;
        product.cnt = order_items[m].quantity;
        // TODO baseURL
        product.image = "http://localhost:3000" + order_items[m].product.images[0].thumb.url;
        // this.products[m].image = this.$axios.baseURL + this.products[m].image.thumb.url;
        tmp_products.push(product);
        tmp_total += order_items[m].subtotal;
      }
      return {
        address_detail: res.data.address.receiver + " " + res.data.address.phone_number
          + " " + res.data.address.post_code + " " + res.data.address.detail_address,
        // address_id: res.data.address.id,
        payment_detail: res.data.payment.holder_name + " **** **** **** " + res.data.payment.card_number.substring(12, 16),
        products: tmp_products,
        totalPrice: tmp_total,
        order_id: params.id,
        order_status: res.data.order.aasm_state,
        shipping_fee: res.data.order.shipping_fee == null ? 0 : res.data.order.shipping_fee,
        is_paid: res.data.order.is_paid == '1' ? true : false,
        placed_on: res.data.order.created_at,
        deliver_on: res.data.order.deliver_at ? res.data.order.deliver_at : ''
      };
    });
  },
  methods: {
    payOrder (params) {
      if (!this.$auth.user.id) {
        // TODO error message
      } else {
        this.$axios.post(`/api/orders/pay_order`, { id: this.order_id }).then((res) => {
          this.alertPay = true;
          this.order_status = res.data.aasm_state;
        });
      }
    },
    showCancelDialog () {
      this.dialogCancel = !this.dialogCancel
    },
    cancelOrder () {
      if (!this.$auth.user.id) {
        // TODO error message
      } else {
        this.$axios.delete(`api/orders/${this.order_id}`).then((res) => {
          this.order_status = res.data.aasm_state;
          this.dialogCancel = false;
        });
      }
    },
    receiveGoods () {
      if (!this.$auth.user.id) {
        // TODO error message
      } else {
        this.$axios.post(`api/orders/receive_good`, { id: this.order_id }).then((res) => {
          this.alertReceive = true;
          this.order_status = res.data.aasm_state;
        });
      }
    },
    rtnToList () {
      this.$router.push(`.`);
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