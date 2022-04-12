<template>
  <v-card>
    <div class="grey lighten-2 d-flex justify-space-around flex-wrap">
      <div class="d-flex my-3 mx-3">
        <p class="text-14 grey--text text--darken-2 mb-0 mr-2">
          Order NO:
        </p>
        <p class="mb-0 grey--text text--darken-4">
          {{orderNo}}
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
      <!-- <div class="d-flex my-3 mx-3">
        <p class="text-14 grey--text text--darken-2 mb-0 mr-2">
          Delivered on:
        </p>
        <p class="mb-0 grey--text text--darken-4">
          {{ deliverOn ? new Date(deliverOn).toLocaleString("ja-jp") :'ー' }}
        </p>
      </div> -->
    </div>
    <div v-for="item in products" :key="item.hashid">
      <div class="d-flex align-center justify-space-around flex-wrap  pa-4">
        <div class="d-flex align-center flex-wrap me-4">
          <router-link :to="{name: 'products-id', params: {id: item.hashid}}">
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
        <v-btn :disabled="isAdmin" text color="brown lighten-1" class="text-capitalize font-weight-bold" @click="$emit('review-product', item.hashid)">Write a Review</v-btn>
      </div>
    </div>
  </v-card>
</template>
<script>
export default {
  name: 'DetailCard',
  props: {
    orderNo: String,
    orderStatus: String,
    placedOn: String,
    deliverOn: String,
    products: Array,
    isAdmin: Boolean
  }
}
</script>
