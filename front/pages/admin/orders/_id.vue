<template>
  <div>
    <div>
      <v-row>
        <v-col cols="12">
          <div class="box-wrapper">
            <div class="box-content">
              <div class="box-container">
                <div class="d-flex justify-space-between flex-wrap mb-5">
                  <div class="d-flex align-center">
                    <v-avatar tile size="25" class="me-3">
                      <v-icon>mdi-shopping</v-icon>
                    </v-avatar>
                    <h2 class="mb-0">Order Details</h2>
                  </div>
                  <div>
                    <v-btn
                      outlined
                      color="brown lighten-1"
                      class="text-capitalize"
                      @click="returnToList">
                      Back To Order List
                    </v-btn>
                  </div>
                </div>
                <v-row>
                  <v-col cols="12">
                    <status-card
                      :is-admin="isAdmin"
                      :order-status="orderStatus"
                      :is-paid="isPaid"
                      :tracking-number="trackingNumber"
                      :carrier="carrier"
                      :deliver-on="deliverOn"
                      @cancel-order="showCancelDialog"
                      @ship-order="showShipDialog">
                    </status-card>
                  </v-col>
                  <v-col cols="12">
                    <detail-card
                      :is-admin="isAdmin"
                      :order-no="orderNo"
                      :order-status="orderStatus"
                      :placed-on="placedOn"
                      :deliver-on="deliverOn"
                      :products="products">
                    </detail-card>
                  </v-col>
                  <v-col cols="12" lg="6">
                    <v-card>
                      <div class="pa-5">
                        <h4 class="mb-3 grey--text text--darken-4">Shipping Address</h4>
                        <p class="text-14 mb-0">
                          {{ addressDetail }}
                        </p>
                      </div>
                    </v-card>
                    <v-card>
                      <div class="pa-5 mt-5">
                        <h4 class="mb-3 grey--text text--darken-4">Payment Informations</h4>
                        <p class="text-14 mb-0">
                          {{ paymentDetail }}
                        </p>
                      </div>
                    </v-card>
                  </v-col>
                  <v-col cols="12" lg="6">
                    <v-card>
                      <div class="pa-5">
                        <h4 class="mb-3 grey--text text--darken-4">Total Summary</h4>
                        <div class="d-flex justify-space-between mb-2">
                          <p class="tex-14 mb-0 grey--text text--darken-2">Subtotal:</p>
                          <p class="tex-14 mb-0 font-weight-bold">¥{{ totalPrice }}</p>
                        </div>
                        <div class="d-flex justify-space-between mb-2">
                          <p class="tex-14 mb-0 grey--text text--darken-2">Shipping fee:</p>
                          <p class="tex-14 mb-0 font-weight-bold">¥{{ shippingFee }}</p>
                        </div>
                        <div class="d-flex justify-space-between mb-2">
                          <p class="tex-14 mb-0 grey--text text--darken-2">Discount:</p>
                          <p class="tex-14 mb-0 font-weight-bold">-</p>
                        </div>
                        <v-divider class="my-3"></v-divider>
                        <div class="d-flex justify-space-between mb-2">
                          <p class="tex-14 mb-0 font-weight-bold">Total:</p>
                          <p class="tex-14 mb-0 font-weight-bold">¥{{ totalPrice }}</p>
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
            <v-dialog v-model="dialogShip" max-width="300px">
              <v-card>
                <v-card-title>Input tracking info</v-card-title>
                <v-divider></v-divider>
                <v-card-text>
                  <br />
                  <v-form ref="form" v-model="valid">
                    <h5 class="mb-3">Carrier <sup class="brown--text">*</sup></h5>
                    <v-select
                      v-model="carrier"
                      outlined
                      dense
                      color="brown lighten-3"
                      item-color="brown lighten-1"
                      :items="carrierList"
                      item-text="label"
                      item-value="slug"
                      :rules="carrierRules"></v-select>
                    <h5 class="mb-3">Tracking Number <sup class="brown--text">*</sup></h5>
                    <v-text-field
                      v-model="trackingNumber"
                      outlined
                      dense
                      color="brown lighten-1"
                      background-color="white"
                      :rules="trackingNumberRules"></v-text-field>
                  </v-form>
                </v-card-text>
                <v-divider></v-divider>
                <v-card-actions>
                  <v-btn color="brown lighten-1" text @click="shipOrder()">Submit</v-btn>
                  <v-btn color="brown lighten-1" text @click="closeShipDialog()">Cancel</v-btn>
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
import StatusCard from "@/components/OrderCard/StatusCard.vue"
import DetailCard from "@/components/OrderCard/DetailCard.vue"
export default {
  components: {
    StatusCard,
    DetailCard,
  },
  middleware: ["auth", "admin"],
  data() {
    return {
      products: [],
      orderNo: "",
      orderStatus: "",
      placedOn: "",
      deliverOn: "",
      addressDetail: "",
      paymentDetail: "",
      totalPrice: 0,
      shippingFee: 0,
      isPaid: false,
      dialogCancel: false,
      dialogShip: false,
      // carrierList: [{ "label": "Sagawa", "slug": "sagawa" }, { "label": "Yamato", "slug": "taqbin-jp" }],
      carrierList: [{ label: "Yamato", slug: "taqbin-jp" }],
      valid: true,
      carrier: "",
      trackingNumber: "",
      carrierRules: [(v) => !!v || "Carrier is required"],
      trackingNumberRules: [(v) => !!v || "Tracking Number is required"],
    }
  },
  computed: {
    isAdmin: function () {
      return this.$auth && this.$auth.user && this.$auth.user.is_admin ? true : false
    },
    displayTrackingInfo: function () {
      return this.orderStatus == "shipping" || this.orderStatus == "delivered" ? true : false
    },
  },
  created() {
    this.loadOrder()
  },
  methods: {
    loadOrder() {
      this.$axios.get(`api/admin/orders/show_order/${this.$route.params.id}`).then((res) => {
        var orderItems = res.data.order_details
        var tmpProducts = []
        var tmpTotal = 0
        for (var m = 0; m < orderItems.length; m++) {
          var product = {}
          product.hashid = orderItems[m].product_hashid
          product.title = orderItems[m].product_title
          product.price = orderItems[m].price
          product.cnt = orderItems[m].quantity
          product.property = orderItems[m].property
          product.image = orderItems[m].image
          tmpProducts.push(product)
          tmpTotal += orderItems[m].subtotal
        }
        this.addressDetail =
          res.data.address.receiver +
          " " +
          res.data.address.phone_number +
          " " +
          res.data.address.post_code +
          " " +
          res.data.address.detail_address
        this.paymentDetail = " Ending With: " + res.data.order.last4
        this.addressId = res.data.address.id
        this.products = tmpProducts
        this.totalPrice = tmpTotal
        this.orderNo = res.data.order.order_no
        this.orderStatus = res.data.order.aasm_state
        this.shippingFee = res.data.order.shipping_fee == null ? 0 : res.data.order.shipping_fee
        this.isPaid = res.data.order.is_paid == "1" ? true : false
        this.placedOn = res.data.order.created_at
        this.deliverOn = res.data.order.deliver_at ? res.data.order.deliver_at : ""
        this.carrier = res.data.order.slug
        this.trackingNumber = res.data.order.tracking_number
      })
    },
    showCancelDialog() {
      this.dialogCancel = !this.dialogCancel
    },
    showShipDialog() {
      this.dialogShip = !this.dialogShip
    },
    closeShipDialog() {
      this.$refs.form.reset()
      this.dialogShip = false
      this.carrier = ""
      this.trackingNumber = ""
    },
    cancelOrder() {
      this.$axios.post(`api/admin/orders/cancel_order`, { order_no: this.orderNo }).then((res) => {
        this.dialogCancel = false
        if (res.data.code === "error") {
          this.$toast.error(res.data.message)
        } else {
          this.orderStatus = res.data.order.aasm_state
          this.$toast.show(res.data.message)
        }
      })
    },
    shipOrder() {
      if (this.$refs.form.validate()) {
        this.$axios
          .post(`api/admin/orders/ship_order`, {
            order_no: this.orderNo,
            slug: this.carrier,
            tracking_number: this.trackingNumber,
          })
          .then((res) => {
            this.dialogShip = false
            if (res.data.code == "error") {
              this.$toast.error(res.data.message)
            } else {
              this.$toast.show(res.data.message)
              this.loadOrder()
            }
          })
      }
    },
    returnToList() {
      this.$router.push(`.`)
    },
  },
}
</script>
