<template>
  <div>
    <v-row justify="center" align="center">
      <v-col cols="5">
        <v-sheet max-width="400" max-height="400" class="mx-auto">
          <v-carousel height="400" light hide-delimiter-background :show-arrows="false">
            <v-carousel-item v-for="(item,i) in images" :key="i">
              <v-row class="fill-height" align="center" justify="center">
                <v-avatar tile size="300">
                  <img :src="item">
                </v-avatar>
              </v-row>
            </v-carousel-item>
          </v-carousel>
        </v-sheet>
      </v-col>
      <v-col cols="5" lg="5">
        <div class="d-flex mb-10"></div>
        <h1 class="mb-4">{{title}}</h1>
        <div class="d-flex mb-4">
          <p class="mb-0">{{sub_title}}</p>
        </div>
        <div class="d-flex mb-4">
          <p class="grey--text text--grey-lighten-1 me-3 mb-0">Rated:</p>
          <div class="d-flex align-center justify-center align-center mb-1">
            <v-rating :value="avg_rate" color="amber" background-color="grey lighten-2" dense half-increments readonly size="16"></v-rating>
            <div class="grey--text text--darken-4 ml-1">
              {{parseFloat(avg_rate).toFixed(1)}}
            </div>
          </div>
        </div>
        <div class="d-flex mb-4">
          <p class="grey--text text--grey-lighten-1 me-3 mb-0">QTY:</p>
          <p class="mb-0">{{quantity}}</p>
        </div>
        <div class="mb-6">
          <h4 class="gray--text lighten-4 text-decoration-line-through mb-0">¥{{original_price}}</h4>
          <h2 class="brown--text text--darken-3">¥{{price}}({{parseFloat(1-discount).toFixed(2)*100}}%OFF)</h2>
          <p v-if="is_available && quantity > 0" class="text-overline">In Stock</p>
          <p v-else class="text-overline">Out Of Stock</p>
        </div>
        <div class="mb-6">
          <v-btn v-if="!$auth.user.is_admin &&is_available && quantity > 0" dark x-large width="250" @click="addToCart" color="brown lighten-1" class="text-capitalize mb-3">
            Add to Cart
          </v-btn>
          <v-btn v-else x-large width="250" color="brown lighten-1" class="text-capitalize mb-3" disabled>
            Add to Cart
          </v-btn>
        </div>
      </v-col>
      <v-col cols="12" class="mt-12">
        <v-tabs v-model="tab" background-color="transparent" color="brown lighten-1">
          <v-tab class="text-capitalize">
            Description
          </v-tab>
          <v-tab class="text-capitalize">
            Review
          </v-tab>
        </v-tabs>

        <v-tabs-items class="transparent my-6 pb-6" v-model="tab">
          <v-tab-item>
            <h3 class="mb-4">Specification :</h3>
            <div v-html="description"></div>
          </v-tab-item>
          <v-tab-item>
            <div class="mb-8" v-for="(item,i) in reviewList" :key="i">
              <div class="d-flex flex-wrap mb-4">
                <v-avatar class="me-3" size="48" color="brown lighten-3">
                  <v-icon dark>mdi-account-circle</v-icon>
                </v-avatar>
                <div>
                  <h5>{{item.user.name}}</h5>
                  <div class="d-flex align-center justify-center mb-1">
                    <v-rating :value="item.rate" color="amber" background-color="grey lighten-2" class="me-2" dense half-increments readonly size="16"></v-rating>
                    <div class="me-2">
                      {{item.rate}}
                    </div>
                    <div class="grey--text text--darken-2">
                      {{ new Date(item.created_at).toLocaleString("ja-jp").slice(0,10) }}
                    </div>
                  </div>
                </div>
              </div>
              <v-row>
                <v-col cols="12" sm="7" md="6" lg="4">
                  {{item.comment}}
                </v-col>
              </v-row>
            </div>
            <h2 class="mb-6">Write a Review for this product</h2>
            <h5 class="mb-3">Your Rating <sup class="brown--text">*</sup></h5>
            <v-rating v-model="rate" color="amber" background-color="grey lighten-2" class="mb-3" dense half-increments size="20"></v-rating>
            <h5 class="mb-3">Your Review <sup class="brown--text">*</sup></h5>
            <v-textarea v-model="comment" color="brown lighten-1" class="mb-3" outlined background-color="white">
            </v-textarea>
            <v-btn dark color="brown lighten-1" class="text-capitalize" @click="reviewProduct">
              Submit
            </v-btn>
          </v-tab-item>
        </v-tabs-items>

        <h3 class="mb-6">Related Products</h3>
        <v-row>
          <v-col v-for="(item, index) in related_products" :key="index" cols="12" sm="4" md="2" lg="2" xl="2">
            <item-card :contentId="item.id" :content-img="item.images[0]" :imageSize="Number(160)" :content-text=" item.title" :originalPrice="item.price" :discount="Number(0.98)" @cartAdd="addToCart(item)">
            </item-card>
          </v-col>
        </v-row>
      </v-col>
    </v-row>
  </div>
</template>
<script>
export default {
  data () {
    return {
      id: '',
      title: '',
      sub_title: '',
      avg_rate: 0,
      description: '',
      original_price: '',
      price: '',
      quantity: '',
      images: [],
      is_available: true,
      tab: null,
      rate: 0,
      comment: '',
      reviewList: [],
      related_products: []
    }
  },
  computed: {
    btn_display () {
      return {
        btn_display: this.$auth.user.is_admin ? 'd-none' : 'd-block'
      }
    }
  },
  asyncData ({ $axios, params }) {
    return $axios.$get(`/api/products/${params.id}`).then((res) => {
      var tmp_images = [];
      if (res && res.product.images) {
        for (var i = 0; i < res.product.images.length; i++) {
          tmp_images.push(res.product.images[i] ? "http://localhost:3000" + res.product.images[i].medium.url : "");
        }
      }
      if (res && res.related_products) {
        for (var j = 0; j < res.related_products.length; j++) {
          res.related_products[j].images[0] = "http://localhost:3000" + res.related_products[j].images[0].medium.url;
        }
      }
      if (res)
        return {
          // TODO 这里的属性是否就默认为data中的属性？
          id: res.product.id,
          title: res.product.title,
          sub_title: res.product.sub_title,
          description: res.product.description,
          price: parseFloat(Number(res.product.price) * Number(res.product.discount)).toFixed(0),
          original_price: res.product.price,
          quantity: res.product.quantity,
          images: tmp_images,
          is_available: res.product.is_available,
          reviewList: res.product.reviews,
          avg_rate: Number(res.avg_rate),
          discount: Number(res.product.discount),
          related_products: res.related_products
        };
    });
  },
  methods: {
    addToCart () {
      // add to backend cart
      if (this.$auth.loggedIn) {
        this.$axios.$post(`api/products/${this.id}/add_to_cart`, {
          product_id: this.id,
          user_id: this.$auth.user.id
        }).then((res) => {
          // console.log(res);
        });
      }
      // add to store
      var cartItem = new Object();
      cartItem.product_id = this.id;
      cartItem.price = this.price;
      this.$store.commit('add_product_to_cart', cartItem);
    },
    reviewProduct () {
      if (this.$auth.loggedIn) {
        this.$axios.$post('api/reviews', {
          product_id: this.id,
          user_id: this.$auth.user.id,
          comment: this.comment,
          rate: this.rate
        }).then((res) => {
          // reset comment input form
          this.comment = '';
          this.rate = 0;
          this.$axios.$get(`api/reviews/find_by_product_id/${this.id}`).then((res) => {
            this.reviewList = res.reviews
          });
        });
      } else {
        // TODO redirect to login page
      }
    },
    // TODO 收藏功能
    addToFavorite () {
    }
  }
};
</script>