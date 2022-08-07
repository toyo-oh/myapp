<template>
  <v-card max-width="100%">
    <v-chip v-if="pDiscount > 0" class="ma-2 p-absolute" color="error" small>
      {{ parseFloat(pDiscount).toFixed(10) * 100 }}%off
    </v-chip>
    <v-card-text>
      <router-link :to="{ name: 'products-id', params: { id: pHashId } }">
        <v-img :src="pImg"></v-img>
      </router-link>
      <router-link
        :to="{ name: 'products-id', params: { id: pHashId } }"
        color="brown lighten-1"
        class="text-decoration-none">
        <h4 class="mb-0 brown--text text--darken-4">{{ pTitle.substring(0, 30) }}</h4>
      </router-link>
      <div class="d-flex justify-space-between">
        <div class="d-flex">
          <h4 class="brown--text lighten-1 mr-2 mb-0 mt-2">
            ¥{{ parseFloat((1 - pDiscount) * originalPrice).toFixed(0) }}
          </h4>
          <h4
            v-if="pDiscount > 0"
            class="gray--text lighten-4 text-decoration-line-through mb-0 mt-2">
            ¥{{ originalPrice }}
          </h4>
        </div>
        <div class="d-flex">
          <v-btn
            class="rounded"
            outlined
            fab
            x-small
            tile
            color="brown lighten-1"
            @click="$emit('cartAdd')">
            <v-icon>mdi-plus</v-icon>
          </v-btn>
        </div>
      </div>
    </v-card-text>
  </v-card>
</template>
<script>
export default {
  name: "ItemCard",
  props: {
    pHashId: { type: String, default: "" },
    pImg: { type: String, default: "" },
    pTitle: { type: String, default: "" },
    subTitle: { type: String, default: "" },
    originalPrice: {
      type: Number,
      default: 10000,
    },
    pRating: {
      type: Number,
      default: 4.5,
    },
    pDiscount: {
      type: Number,
      default: 0,
    },
  },
  data() {
    return {
      dialog: false,
    }
  },
}
</script>
<style lang="scss" scoped>
.p-absolute {
  position: absolute !important;
  z-index: 3;
}
</style>
