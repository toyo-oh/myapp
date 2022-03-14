<template>
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
        <div v-if="isAdmin">
          <v-btn v-if="displayCancelBtn" color="brown lighten-1" dark large @click="$emit('cancel-order')">
            Cancel Order
          </v-btn>
          <v-btn v-if="displayShipBtn" color="brown lighten-1" dark large @click="$emit('ship-order')">
            Ship
          </v-btn>
        </div>
        <div v-if="!isAdmin">
          <v-btn v-if="displayPayBtn" dark color="brown lighten-1" class="text-capitalize" @click="$emit('pay-order')">
            Pay Order
          </v-btn>
          <v-btn v-if="displayCancelBtn" dark color="brown lighten-1" class="text-capitalize" @click="$emit('cancel-order')">
            Cancel Order
          </v-btn>
          <v-btn v-if="displayReceiveBtn" dark color="brown lighten-1" class="text-capitalize" @click="$emit('receive-good')">
            Receive goods
          </v-btn>
        </div>
      </div>
    </div>
  </v-card>
</template>
<script>
export default {
  name: 'StatusCard',
  props: {
    isAdmin: Boolean,
    orderStatus: String,
    isPaid: Boolean
  },
  data () {
    return {
    }
  },
  computed: {
    displayCancelBtn: function () {
      return this.orderStatus == 'order_placed' || this.orderStatus == 'paid' ? true : false
    },
    displayPayBtn: function () {
      return this.orderStatus == 'order_placed' ? true : false
    },
    displayReceiveBtn: function () {
      return this.orderStatus == 'shipping' ? true : false
    },
    displayShipBtn: function () {
      return this.orderStatus == 'paid' ? true : false
    }
  }
}
</script>