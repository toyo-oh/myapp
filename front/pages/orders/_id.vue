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
                  <div class="d-flex justify-start">
                    <div v-if="displayCancelledLbl" class="py-2 px-5 brown lighten-4 brown--text text-center text-wrap rounded-pill">
                      Order Status:<span class="font-weight-bold">{{orderStatus}}</span>
                    </div>
                    <div v-if="displayCancelBtn" class="d-flex justify-end">
                      <v-btn dark color="brown lighten-1" class="text-capitalize" @click="showCancelDialog">
                        Cancel Order
                      </v-btn>
                    </div>
                  </div>
                </v-col>
                <v-col cols="12">
                  <div v-if="!displayCancelledLbl">
                    <v-card>
                      <v-card-title class="pa-2 brown lighten-3">
                        <h3 class="text-h6 font-weight-light text-center grow">
                          Tracking History - {{tracking_title}}
                        </h3>
                      </v-card-title>
                      <v-card-text>
                        <template v-if="checkpoints.length >0">
                          <v-timeline align-top dense>
                            <v-timeline-item color="brown lighten-2" small v-for="item in checkpoints" :key="item.index">
                              <v-row class="pt-1">
                                <v-col cols="3">
                                  <strong>{{item.status}}</strong>
                                </v-col>
                                <v-col>
                                  <strong>{{item.placeName}}</strong>
                                  <div class="text-caption">
                                    {{item.date + ' ' + item.time}}
                                  </div>
                                </v-col>
                              </v-row>
                            </v-timeline-item>
                          </v-timeline>
                        </template>
                        <template v-else>
                          <br>
                          The tracking Information will be shown here when we get updates from the carrier.
                        </template>
                      </v-card-text>
                      <v-divider></v-divider>
                      <div class="d-flex justify-space-around flex-wrap">
                        <div class="d-flex my-3 mx-3">
                          <p class="text-14 grey--text text--darken-2 mb-0 mr-2">
                            Tracking NO:
                          </p>
                          <p class="mb-0 grey--text text--darken-4">
                            {{tracking_number ? tracking_number : 'ー'}}
                          </p>
                        </div>
                        <div class="d-flex my-3 mx-3">
                          <p class="text-14 grey--text text--darken-2 mb-0 mr-2">
                            Carrier:
                          </p>
                          <p class="mb-0 grey--text text--darken-4">
                            {{slug ?  slug : 'ー'}}
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
                    </v-card>
                  </div>
                </v-col>
                <v-col cols="12">
                  <detail-card :isAdmin="isAdmin" :orderNo="orderNo" :orderStatus="orderStatus" :placedOn="placedOn" :deliverOn="deliverOn" :products="products" @review-product="showReviewDialog"> </detail-card>
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
import DetailCard from '@/components/OrderCard/DetailCard.vue';
import ReviewForm from '@/components/inputForm/ReviewForm.vue';
export default {
  middleware: 'auth',
  components: {
    DetailCard,
    ReviewForm
  },
  data () {
    return {
      products: [],
      totalPrice: 0,
      shippingFee: 0,
      orderNo: '',
      orderStatus: '',
      isPaid: false,
      placedOn: '',
      deliverOn: '',
      slug: '',
      tracking_number: '',
      addressDetail: '',
      paymentDetail: '',
      reviewPid: null,
      reviewDialog: false,
      dialogCancel: false,
      isAdmin: this.$auth && this.$auth.user && this.$auth.user.is_admin ? true : false,
      checkpoints: [],
      tracking_title: ''
    };
  },
  computed: {
    displayCancelBtn: function () {
      return this.orderStatus == 'order_placed' || this.orderStatus == 'paid' ? true : false
    },
    displayCancelledLbl: function () {
      return this.orderStatus == 'order_cancelled' ? true : false
    }
  },
  created () {
    this.loadOrder();
  },
  methods: {
    loadOrder () {
      this.$axios.get(`api/orders/show_order/${this.$route.params.id}`).then((res) => {
        var orderItems = res.data.order_details;
        var tmpProducts = [];
        var tmpTotal = 0;
        for (var m = 0; m < orderItems.length; m++) {
          var product = {};
          product.hashid = orderItems[m].product_hashid;
          product.title = orderItems[m].product_title;
          product.price = orderItems[m].price;
          product.cnt = orderItems[m].quantity;
          product.property = orderItems[m].property;
          product.image = "http://localhost:3000" + orderItems[m].image;
          tmpProducts.push(product);
          tmpTotal += orderItems[m].subtotal;
        }
        this.addressDetail = res.data.address.receiver + " " + res.data.address.phone_number
          + " " + res.data.address.post_code + " " + res.data.address.detail_address;
        this.paymentDetail = " Ending With: " + res.data.order.last4;
        this.products = tmpProducts;
        this.totalPrice = tmpTotal;
        this.orderNo = res.data.order.order_no;
        this.orderStatus = res.data.order.aasm_state;
        this.shippingFee = res.data.order.shipping_fee == null ? 0 : res.data.order.shipping_fee;
        this.isPaid = res.data.order.is_paid == '1' ? true : false;
        this.placedOn = res.data.order.created_at;
        this.deliverOn = res.data.order.deliver_at ? res.data.order.deliver_at : '';
        this.slug = res.data.order.slug;
        this.tracking_number = res.data.order.tracking_number;
        if (this.tracking_number) {
          this.fetchTracking();
        } else {
          this.tracking_title = 'Order confirmed';
        }
      }).catch((err) => {
        if (err.response && err.response.status === 401) {
          this.$router.push('/orders');
          this.$toast.error('Unauthorized!');
        }
      });
    },
    fetchTracking () {
      // const options = {
      //   method: 'GET',
      //   headers: {
      //     Accept: 'application/json',
      //     'Content-Type': 'application/json',
      //     'aftership-api-key': `${process.env.AFTERSHIP_PK}`
      //   }
      // }
      // fetch(`https://api.aftership.com/v4/trackings/${this.slug}/${this.tracking_number}`, options)
      //   .then(response => response.json())
      //   .then(response => {
      //     if (response.meta.code === 200) {
      //       this.checkpoints = response.data.tracking.checkpoints;
      //       this.tracking_title = this.checkpoints ? this.checkpoints[this.checkpoints.length - 1].tag : 'Order confirmed';
      //     }
      //   })
      //   .catch(err => console.error(err));

      this.$axios.get(`tracking_api/${this.tracking_number}.json`)
        .then(response => {
          // resultは0が正常終了0以外が異常終了(-1: 伝票番号誤り/伝票番号未登録)
          if (response.data.result === "0") {
            this.checkpoints = response.data.statusList;
            this.tracking_title = response.data.status ? response.data.status : 'Order confirmed';
          }
        })
        .catch(err => console.error(err));
    },
    showReviewDialog (e) {
      this.reviewDialog = true;
      this.reviewPid = e;
    },
    showCancelDialog () {
      this.dialogCancel = !this.dialogCancel
    },
    cancelOrder () {
      if (!this.$auth.loggedIn) {
        this.$toast.error('Please login in before cancel the order!');
      } else {
        this.$axios.post('api/orders/cancel_order', { order_no: this.orderNo }).then((res) => {
          if (res.data.code == "error") {
            this.dialogCancel = false;
            this.$toast.error(res.data.message);
          } else {
            this.orderStatus = res.data.order.aasm_state;
            this.dialogCancel = false;
            this.$toast.show(res.data.message);
          }
        });
      }
    },
    // payOrder () {
    //   if (!this.$auth.loggedIn) {
    //     this.$toast.error('Please login in before pay the order!');
    //   } else {
    //     this.$axios.post('/api/orders/pay_order', { order_no: this.orderNo }).then((res) => {
    //       this.orderStatus = res.data.aasm_state;
    //       this.$toast.show('Order paid successfully!');
    //     });
    //   }
    // },
    // receiveGoods () {
    //   if (!this.$auth.loggedIn) {
    //     this.$toast.error('Please login in before receive the order!');
    //   } else {
    //     this.$axios.post('api/orders/receive_good', { order_no: this.orderId }).then((res) => {
    //       this.$toast.show('Receive order successfully!');
    //       this.orderStatus = res.data.aasm_state;
    //     });
    //   }
    // },
    rtnToList () {
      this.$router.push(`.`);
    }
  }
};
</script>