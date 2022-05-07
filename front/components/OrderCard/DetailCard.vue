<template>
  <v-card>
    <div class="brown lighten-3 d-flex justify-space-around flex-wrap">
      <div class="d-flex my-3 mx-3">
        <p class="text-14 grey--text text--darken-2 mb-0 mr-2">Order NO:</p>
        <p class="mb-0 grey--text text--darken-4">
          {{ orderNo }}
        </p>
      </div>
      <div class="d-flex my-3 mx-3">
        <p class="text-14 grey--text text--darken-2 mb-0 mr-2">Placed on:</p>
        <p class="mb-0 grey--text text--darken-4">
          {{ new Date(placedOn).toLocaleString("ja-jp") }}
        </p>
      </div>
    </div>
    <div v-for="item in products" :key="item.hashid">
      <div class="d-flex align-center justify-space-around flex-wrap pa-4">
        <v-row>
          <v-col cols="2"> </v-col>
          <v-col cols="3">
            <div class="d-flex align-center flex-wrap me-4">
              <router-link :to="{ name: 'products-id', params: { id: item.hashid } }">
                <v-avatar tile size="64" class="me-4">
                  <img :src="item.image" max-height="100" max-width="100" />
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
          </v-col>
          <v-col cols="4">
            <div class="d-flex align-center flex-wrap me-4 mt-4">
              <p class="mb-0 grey--text text--darken-2">
                {{ item.property }}
              </p>
            </div>
          </v-col>
          <v-col cols="3">
            <v-btn
              :disabled="isAdmin"
              text
              color="brown lighten-1"
              class="text-capitalize font-weight-bold mt-4"
              @click="$emit('review-product', item.hashid)"
              >Write a Review</v-btn
            >
          </v-col>
        </v-row>
      </div>
    </div>
  </v-card>
</template>
<script>
export default {
  name: "DetailCard",
  props: {
    orderNo: { type: String, default: "" },
    orderStatus: { type: String, default: "" },
    placedOn: { type: String, default: "" },
    deliverOn: { type: String, default: "" },
    products: { type: Array, default: () => [] },
    isAdmin: { type: Boolean, default: false },
  },
}
</script>
