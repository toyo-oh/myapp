<template>
  <v-card class="mb-4">
    <div class="grey lighten-3 d-flex justify-space-around flex-wrap">
      <div class="d-flex my-3 mx-3">
        <p class="text-14 grey--text text--darken-2 mb-0 mr-2">
          Order NO:
        </p>
        <p class="mb-0 grey--text text--darken-4">
          {{order.orderNo}}
        </p>
      </div>
      <div class="d-flex my-3 mx-3">
        <p class="text-14 grey--text text--darken-2 mb-0 mr-2">
          Order Status:
        </p>
        <p class="mb-0 grey--text text--darken-4">
          {{order.orderStatus}}
        </p>
      </div>
      <div class="d-flex my-3 mx-3">
        <p class="text-14 grey--text text--darken-2 mb-0 mr-2">
          Created At:
        </p>
        <p class="mb-0 grey--text text--darken-4">
          {{ new Date(order.createdAt).toISOString().slice(0, 10) }}
        </p>
      </div>
      <div class="d-flex my-3 mx-3">
        <v-btn outlined color="brown lighten-1" class="mr-2" @click="getOrderDetail(order.orderNo)">View Detail</v-btn>
      </div>
    </div>
    <div v-for="item in details" :key="item.id">
      <div class="d-flex align-center justify-space-around flex-wrap  pa-4">
        <div class="d-flex align-center flex-wrap me-4">
          <router-link :to="{name: 'products-id', params: {id: item.product_hashid}}">
            <v-avatar tile size="64" class="me-4">
              <img :src="item.image" max-height="100" max-width="100">
            </v-avatar>
          </router-link>
          <div>
            <div class="text-14">
              {{ item.product_title }}
            </div>
            <div class="text-14 grey--text text--darken-2">
              ¥{{ item.price }} x {{ item.quantity }}
            </div>
          </div>
        </div>
        <p class="mb-0 grey--text text--darken-2">
          Product properties: TODO
        </p>
        <!-- <v-btn :disabled="isAdmin" text color="brown lighten-1" class="text-capitalize font-weight-bold" @click="$emit('review-product', item.id)">Write a Review</v-btn> -->
      </div>
    </div>
    <div class="grey lighten-3 d-flex justify-space-around flex-wrap">
      <div class="d-flex my-3 mx-3">
        <p class="text-14 grey--text text--darken-2 mb-0 mr-2">
          <strong>SubTotal:</strong>
        </p>
        <p class="mb-0 grey--text text--darken-4">
          ¥{{order.amountTotal}}
        </p>
      </div>
      <div class="d-flex my-3 mx-3">
        <p class="text-14 grey--text text--darken-2 mb-0 mr-2">
          <strong>Shipping:</strong>
        </p>
        <p class="mb-0 grey--text text--darken-4">
          ¥{{order.shippingFee ? order.shippingFee : 0}}
        </p>
      </div>
      <div class="d-flex my-3 mx-3">
        <p class="text-14 grey--text text--darken-2 mb-0 mr-2">
          <strong>Order Total:</strong>
        </p>
        <p class="mb-0 grey--text text--darken-4">
          ¥{{ order.amountTotal+ order.shippingFee}}
        </p>
      </div>
    </div>
  </v-card>
</template>
<script>
export default {
  name: 'ListCard',
  props: {
    order: Object,
    details: Array
  },
  methods: {
    getOrderDetail (orderNo) {
      this.$router.push(`/orders/${orderNo}`)
    }
  }
}
</script>
