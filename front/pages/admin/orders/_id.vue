<template>
  <div>
    <v-alert v-model="alertCancel" type="success" close-text="Close Alert" dismissible>
      Order cancelled successfully！
    </v-alert>
    <v-alert v-model="alertShip" type="success" close-text="Close Alert" dismissible>
      Order shipped successfully！
    </v-alert>
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
                    <v-btn outlined color="brown lighten-1" class="text-capitalize" @click="returnToList">
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
                            <v-btn v-if="display_cancel_btn" color="brown lighten-1" dark large @click="showCancelDialog()">
                              Cancel Order
                            </v-btn>
                            <v-btn v-if="display_ship_btn" color="brown lighten-1" dark large @click="shipOrder">
                              Ship
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
                          <v-btn disabled text color="brown lighten-1" class="text-capitalize font-weight-bold">Write a Review</v-btn>
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
                            ¥{{logisticsFee}}
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
                            ¥{{totalPrice}}
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
  </div>
</template>

<script>
export default {
  middleware: ['auth', 'admin'],
  data () {
    return {
      products: [],
      totalPrice: 0,
      logisticsFee: 0,
      orderId: '',
      addressDetail: '',
      paymentDetail: '',
      orderStatus: '',
      alertCancel: false,
      alertShip: false,
      dialogCancel: false,
      isPaid: false,
      placedOn: '',
      deliverOn: ''
    };
  },
  computed: {
    display_cancel_btn: function () {
      return this.orderStatus == 'order_placed' || this.orderStatus == 'paid' ? true : false
    },
    display_ship_btn: function () {
      return this.orderStatus == 'paid' ? true : false
    },
    display_order_status: function () {
      return this.orderStatus;
    }
  },
  asyncData ({ $axios, params }) {
    return $axios.get(`api/admin/orders/${params.id}`).then((res) => {
      var orderItems = res.data.order_details;
      var tmpProducts = [];
      var tmpTotal = 0;
      for (var m = 0; m < orderItems.length; m++) {
        var product = {};
        product.id = orderItems[m].product_id;
        product.title = orderItems[m].product_title;
        product.price = orderItems[m].price;
        product.cnt = orderItems[m].quantity;
        // TODO baseURL
        product.image = "http://localhost:3000" + orderItems[m].product.images[0].thumb.url;
        // this.products[m].image = this.$axios.baseURL + this.products[m].image.thumb.url;
        tmpProducts.push(product);
        tmpTotal += orderItems[m].subtotal;
      }
      return {
        addressDetail: res.data.address.receiver + " " + res.data.address.phone_number
          + " " + res.data.address.post_code + " " + res.data.address.detail_address,
        paymentDetail: res.data.payment.holder_name + " **** **** **** " + res.data.payment.card_number.substring(12, 16),
        addressId: res.data.address.id,
        products: tmpProducts,
        totalPrice: tmpTotal,
        orderId: params.id,
        orderStatus: res.data.order.aasm_state,
        logisticsFee: res.data.order.logistics_fee == null ? 0 : res.data.order.logistics_fee,
        isPaid: res.data.order.is_paid == '1' ? true : false,
        placedOn: res.data.order.created_at,
        deliverOn: res.data.order.deliver_at ? res.data.order.deliver_at : ''
      };
    });
  },
  methods: {
    showCancelDialog () {
      this.dialogCancel = !this.dialogCancel
    },
    cancelOrder () {
      this.$axios.delete(`api/admin/orders/${this.orderId}`).then((res) => {
        this.orderStatus = res.data.aasm_state;
        this.dialogCancel = false;
        this.alertCancel = true;
      });
    },
    shipOrder () {
      this.$axios.post(`api/admin/orders/ship_order`, { id: this.orderId }).then((res) => {
        this.orderStatus = res.data.aasm_state;
        this.alertShip = true;
      });
    },
    returnToList () {
      this.$router.push(`.`);
    }
  }
};
</script>