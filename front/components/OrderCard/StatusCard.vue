<template>
  <v-card>
    <div class="px-6 pt-8 pb-8">
      <div class="d-flex justify-start mb-10">
        <div class="py-2 px-5 brown lighten-4 brown--text text-center text-wrap rounded-pill">
          <p class="mb-0">
            Order Status:
            <span class="font-weight-bold">{{ orderStatus }}</span>
          </p>
        </div>
      </div>
      <div v-if="orderStatus == 'order_cancelled'" class="d-flex align-center">
        <div class="p-relative">
          <v-avatar size="72" color="brown lighten-2">
            <v-badge color="green lighten-1" icon="mdi-check">
              <v-icon color="grey lighten-4">mdi-cube-outline</v-icon>
            </v-badge>
          </v-avatar>
        </div>
        <v-sheet
          v-if="isPaid"
          color="brown lighten-1"
          elevation="0"
          height="4"
          class="flex-grow-1"></v-sheet>
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
      <div v-else class="d-flex align-center">
        <div class="p-relative">
          <v-avatar size="72" color="brown lighten-2">
            <v-badge color="green lighten-1" icon="mdi-check">
              <v-icon color="grey lighten-4">mdi-cube-outline</v-icon>
            </v-badge>
          </v-avatar>
        </div>
        <v-sheet
          :color="
            orderStatus == 'paid' || orderStatus == 'shipping' || orderStatus == 'delivered'
              ? 'brown lighten-1'
              : 'grey lighten-2'
          "
          elevation="0"
          height="4"
          class="flex-grow-1"></v-sheet>
        <div>
          <template
            v-if="orderStatus == 'paid' || orderStatus == 'shipping' || orderStatus == 'delivered'">
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
        <v-sheet
          :color="
            orderStatus == 'shipping' || orderStatus == 'delivered'
              ? 'brown lighten-1'
              : 'grey lighten-2'
          "
          elevation="0"
          height="4"
          class="flex-grow-1"></v-sheet>
        <div>
          <template v-if="orderStatus == 'shipping' || orderStatus == 'delivered'">
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
        <v-sheet
          :color="orderStatus == 'delivered' ? 'brown lighten-1' : 'grey lighten-2'"
          elevation="0"
          height="4"
          class="flex-grow-1"></v-sheet>
        <div>
          <template v-if="orderStatus == 'delivered'">
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
        <div v-if="isAdmin">
          <v-btn
            v-if="displayCancelBtn"
            color="brown lighten-1"
            dark
            large
            @click="$emit('cancel-order')">
            Cancel Order
          </v-btn>
          <v-btn
            v-if="displayShipBtn"
            color="brown lighten-1"
            dark
            large
            @click="$emit('ship-order')">
            Ship
          </v-btn>
        </div>
        <div v-if="!isAdmin">
          <v-btn
            v-if="displayCancelBtn"
            dark
            color="brown lighten-1"
            class="text-capitalize"
            @click="$emit('cancel-order')">
            Cancel Order
          </v-btn>
        </div>
      </div>
      <v-divider v-if="displayTrackingInfo && isAdmin"></v-divider>
      <div v-if="displayTrackingInfo && isAdmin" class="d-flex justify-space-around flex-wrap">
        <div class="d-flex my-3 mx-3">
          <p class="text-14 grey--text text--darken-2 mb-0 mr-2">Tracking NO:</p>
          <p class="mb-0 grey--text text--darken-4">
            {{ trackingNumber ? trackingNumber : "ー" }}
          </p>
        </div>
        <div class="d-flex my-3 mx-3">
          <p class="text-14 grey--text text--darken-2 mb-0 mr-2">Carrier:</p>
          <p class="mb-0 grey--text text--darken-4">
            {{ carrier ? carrier : "ー" }}
          </p>
        </div>
        <div class="d-flex my-3 mx-3">
          <p class="text-14 grey--text text--darken-2 mb-0 mr-2">Delivered on:</p>
          <p class="mb-0 grey--text text--darken-4">
            {{ deliverOn ? new Date(deliverOn).toLocaleString("ja-jp") : "ー" }}
          </p>
        </div>
      </div>
    </div>
  </v-card>
</template>
<script>
export default {
  name: "StatusCard",
  props: {
    isAdmin: { type: Boolean, default: false },
    orderStatus: { type: String, default: "" },
    isPaid: { type: Boolean, default: false },
    trackingNumber: { type: String, default: "" },
    carrier: { type: String, default: "" },
    deliverOn: { type: String, default: "" },
  },
  data() {
    return {}
  },
  computed: {
    displayCancelBtn: function () {
      return this.orderStatus == "order_placed" || this.orderStatus == "paid" ? true : false
    },
    displayShipBtn: function () {
      return this.orderStatus == "paid" ? true : false
    },
    displayTrackingInfo: function () {
      return this.orderStatus == "shipping" || this.orderStatus == "delivered" ? true : false
    },
  },
}
</script>
