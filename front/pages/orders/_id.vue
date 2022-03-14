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
                  <status-card :isAdmin="isAdmin" :orderStatus="orderStatus" :isPaid="isPaid" @pay-order="payOrder" @cancel-order="showCancelDialog" @receive-good="receiveGoods"></status-card>
                </v-col>
                <v-col cols="12">
                  <detail-card :isAdmin="isAdmin" :orderId="orderId" :orderStatus="orderStatus" :placedOn="placedOn" :deliverOn="deliverOn" :products="products" @review-product="showReviewDialog"> </detail-card>
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
                        Payment Informations
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
          <review-form :reviewPid="reviewPid" :reviewDialog.sync="reviewDialog"></review-form>
        </div>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import StatusCard from '@/components/OrderCard/StatusCard.vue';
import DetailCard from '@/components/OrderCard/DetailCard.vue';
import ReviewForm from '@/components/inputForm/ReviewForm.vue';
export default {
  middleware: 'auth',
  components: {
    StatusCard,
    DetailCard,
    ReviewForm
  },
  data () {
    return {
      products: [],
      totalPrice: 0,
      shippingFee: 0,
      orderId: null,
      orderStatus: '',
      isPaid: false,
      placedOn: '',
      deliverOn: '',
      addressDetail: '',
      paymentDetail: '',
      reviewPid: null,
      reviewDialog: false,
      dialogCancel: false,
      isAdmin: this.$auth && this.$auth.user && this.$auth.user.is_admin ? true : false
    };
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
          product.image = "http://localhost:3000" + orderItems[m].image;
          tmpProducts.push(product);
          tmpTotal += orderItems[m].subtotal;
        }
        this.addressDetail = res.data.address.receiver + " " + res.data.address.phone_number
          + " " + res.data.address.post_code + " " + res.data.address.detail_address;
        this.paymentDetail = res.data.payment.holder_name + " Ending With: " + res.data.payment.card_number.substring(12, 16);
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
    showReviewDialog (e) {
      this.reviewDialog = true;
      this.reviewPid = e;
    },
    showCancelDialog () {
      this.dialogCancel = !this.dialogCancel
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
    }
  }
};
</script>