<template>
  <v-card max-width="100%">
    <v-chip v-if="pDiscount>0" class="ma-2 p-absolute" color="error" small>
      {{parseFloat(pDiscount).toFixed(10)*100}}%off
    </v-chip>
    <v-card-text>
      <router-link :to="{name: 'products-id', params: {id: pId}}">
        <v-img :src="pImg"></v-img>
      </router-link>
      <router-link :to="{name: 'products-id', params: {id: pId}}" color="brown lighten-1" class="text-decoration-none">
        <h3 class="mb-0 brown--text text--darken-4">{{pTitle}} </h3>
      </router-link>
      <div class="d-flex mb-1 grey--text">
        {{subTitle ? subTitle.substring(0, 25) : ""}}
      </div>
      <div class="d-flex justify-space-between">
        <div class="d-flex">
          <h4 class="brown--text lighten-1 mr-2 mb-0">¥{{parseFloat((1-pDiscount)*originalPrice).toFixed(0)}} </h4>
          <h4 v-if="pDiscount>0" class="gray--text lighten-4 text-decoration-line-through mb-0">¥{{originalPrice}}</h4>
        </div>
        <div class="d-flex">
          <v-btn class="rounded" outlined fab x-small tile color="brown lighten-1" @click="$emit('cartAdd')">
            <v-icon>mdi-plus</v-icon>
          </v-btn>
        </div>
      </div>
    </v-card-text>
  </v-card>
</template>
<script>
export default {
  name: 'ItemCard',
  props: {
    pId: {
      type: Number,
      default: 0
    },
    pImg: String,
    pTitle: String,
    subTitle: String,
    originalPrice: {
      type: Number,
      default: 10000
    },
    pRating: {
      type: Number,
      default: 4.5
    },
    pDiscount: {
      type: Number,
      default: 0
    }
  },
  data () {
    return {
      dialog: false,
    }
  },
}
</script>
<style lang="scss" scoped>
.p-absolute {
  position: absolute !important;
  z-index: 999;
}
</style>