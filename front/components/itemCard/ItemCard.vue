<template>
  <base-card class="card-hover" :class="cardHoverShadow ? 'card-hover-shadow' : '' ">
    <v-chip v-if="discount<1" class="ma-2 p-absolute" color="error" small>
      {{parseFloat(1-discount).toFixed(10)*100}}%off
    </v-chip>
    <router-link :to="{name: 'products-id', params: {id: contentId}}">
      <v-img height="250" class="br-t-8" :src="contentImg"></v-img>
    </router-link>
    <v-card-text class=" d-flex justify-content-between align-end">
      <div class="flex-grow-1 my-3">
        <router-link :to="{name: 'products-id', params: {id: contentId}}" color="brown lighten-1">
          <h3 class="mb-0 brown--text text--darken-4">{{contentText}} </h3>
        </router-link>
        <div class="d-flex mb-1">
          <!-- <v-rating :value="contentRating" color="amber" background-color="amber" dense half-increments readonly size="14"></v-rating>
          <div class="grey--text ml-1">
            {{contentRating}}
          </div> -->
          <div class="grey--text ml-1">
            {{subTitle}}
          </div>
        </div>
        <div class="d-flex">
          <h4 class="brown--text lighten-1 mr-2 mb-0">¥{{parseFloat(discount*originalPrice).toFixed(0)}} </h4>
          <h4 class="gray--text lighten-4 text-decoration-line-through mb-0">¥{{originalPrice}}</h4>
        </div>
      </div>
      <div class="d-flex flex-column">
        <v-btn class="rounded" outlined fab x-small tile color="brown lighten-1" @click="$emit('cartAdd')">
          <v-icon>mdi-plus</v-icon>
        </v-btn>
      </div>
    </v-card-text>
  </base-card>
</template>
<script>
export default {
  props: {
    btnText: {
      type: String,
      default: ''
    },
    cardHoverShadow: {
      type: Boolean,
      default: false
    },
    contentId: {
      type: Number,
      default: 0
    },
    counter: {
      type: Number,
      default: 0
    },
    contentImg: String,
    contentText: String,
    subTitle: String,
    originalPrice: {
      type: Number,
      default: 10000
    },
    contentRating: {
      type: Number,
      default: 4.5
    },
    discount: {
      type: Number,
      default: 1
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
.br-t-8 {
  border-top-right-radius: 8px;
  border-top-left-radius: 8px;
}
.card-hover {
  &:hover {
    .card-hover-icon {
      display: block;
    }
  }
  .card-hover-icon {
    display: none;
  }
}
</style>