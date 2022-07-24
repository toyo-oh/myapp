<template>
  <v-card max-width="100%">
    <v-card-text>
      <router-link :to="{ name: 'products-id', params: { id: pHashId } }">
        <v-img :src="pImg"></v-img>
      </router-link>
      <router-link
        :to="{ name: 'products-id', params: { id: pHashId } }"
        class="text-decoration-none">
        <h5 class="grey--text text--darken-4">{{ pTitle.substring(0, 24) }}</h5>
      </router-link>
      <div class="d-flex justify-space-between">
        <div class="d-flex">
          <h5 class="brown--text me-2">
            ¥{{ parseFloat((1 - pDiscount) * originalPrice).toFixed(0) }}
          </h5>
          <h5 v-if="pDiscount > 0" class="grey--text text--darken-1 text-decoration-line-through">
            ¥{{ originalPrice }}
          </h5>
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
  name: "SmallCard",
  props: {
    pId: {
      type: Number,
      default: 0,
    },
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
<style lang="scss" scoped></style>
