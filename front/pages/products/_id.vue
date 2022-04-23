<template>
  <div>
    <v-row justify="center" align="center">
      <v-col cols="5">
        <v-sheet max-width="400" max-height="400" class="mx-auto">
          <v-carousel height="400" light hide-delimiter-background :show-arrows="false">
            <v-carousel-item v-for="(item,i) in images" :key="i">
              <v-row class="fill-height" align="center" justify="center">
                <v-avatar tile size="300">
                  <v-img :src="item"></v-img>
                </v-avatar>
              </v-row>
            </v-carousel-item>
          </v-carousel>
        </v-sheet>
      </v-col>
      <v-col cols="5" lg="5">
        <div class="d-flex mb-10"></div>
        <h1 class="mb-4">{{title}}</h1>
        <div class="d-flex">
          <p class="mt-2">{{subTitle}}</p>
          <div>
            <fav-button :isFav="isFav" :phashid="hashid"></fav-button>
          </div>
        </div>
        <div class="d-flex mb-4">
          <p class="grey--text text--grey-lighten-1 me-3 mb-0">Rated:</p>
          <div class="d-flex align-center justify-center align-center mb-1">
            <v-rating :value="avgRate" color="amber" background-color="grey lighten-2" dense half-increments readonly size="16"></v-rating>
            <div class="grey--text text--darken-4 ml-1">
              {{parseFloat(avgRate).toFixed(1)}}
            </div>
          </div>
        </div>
        <div class="d-flex mb-4">
          <p class="grey--text text--grey-lighten-1 me-3 mb-0">QTY:</p>
          <p class="mb-0">{{quantity}}</p>
        </div>
        <div class="mb-6">
          <h4 v-if="discount>0" class="gray--text lighten-4 text-decoration-line-through mb-0">¥{{originalPrice}}</h4>
          <h2 v-if="discount>0" class="brown--text text--darken-3">¥{{price}}({{parseFloat(discount).toFixed(2)*100}}%OFF)</h2>
          <h2 v-else class="brown--text text--darken-3">¥{{price}}</h2>
          <p v-if="isAvailable && quantity > 0" class="text-overline">In Stock</p>
          <p v-else class="text-overline">Out Of Stock</p>
        </div>
        <div class="mb-6">
          <v-btn v-if="!is_admin &&isAvailable && quantity > 0" dark x-large width="250" @click="addToCart({'hashid':hashid, 'price':price})" color="brown lighten-1" class="text-capitalize mb-3">
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
            <div class="mb-8" v-for="(item, i) in reviewList" :key="i">
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

        <v-snackbar v-model="reviewAlert" timeout="3000">
          Please login in before review the product
          <template v-slot:action="{ attrs }">
            <v-btn color="brown" text v-bind="attrs" @click="reviewAlert = false">Close</v-btn>
          </template>
        </v-snackbar>

        <h3 class="mb-6">Related Products</h3>
        <v-row>
          <v-col v-for="(item, index) in relatedProducts" :key="index" cols="12" xs="4" sm="4" md="2" lg="2" xl="2">
            <item-card :pHashId="item.hashid" :pImg="item.images[0]" :pTitle="item.title" :originalPrice="item.price" :pDiscount="Number(item.discount)" @cartAdd="addToCart({'hashid':item.hashid, 'price':parseFloat(Number(item.price) * (1 - Number(item.discount))).toFixed(0)})">
            </item-card>
          </v-col>
        </v-row>
      </v-col>
    </v-row>
  </div>
</template>
<script>
import { mapActions } from 'vuex'
import ItemCard from "@/components/productCard/ItemCard";
import FavButton from "@/components/common/FavButton";
export default {
  components: {
    ItemCard,
    FavButton
  },
  data () {
    return {
      hashid: '',
      title: '',
      subTitle: '',
      avgRate: 0,
      description: '',
      originalPrice: '',
      price: '',
      quantity: '',
      images: [],
      isAvailable: true,
      tab: null,
      rate: 0,
      comment: '',
      reviewList: [],
      relatedProducts: [],
      reviewAlert: false,
      discount: 0,
      isFav: false
    }
  },
  computed: {
    is_admin () {
      return this.$auth && this.$auth.user && this.$auth.user.is_admin ? true : false
    }
  },
  asyncData ({ $axios, params, error }) {
    return $axios.$get(`/api/products/${params.id}`).then((res) => {
      var tmp_images = [];
      if (res && res.product.images) {
        for (var i = 0; i < res.product.images.length; i++) {
          tmp_images.push(res.product.images[i] ? "http://localhost:3000" + res.product.images[i].medium.url : "");
          // tmp_images.push(res.product.images[i] ? this.$axios.browserBaseURL + '/api' + res.roduct.images[i].medium.url : "");
        }
      }
      if (res && res.related_products) {
        for (var j = 0; j < res.related_products.length; j++) {
          res.related_products[j].images[0] = "http://localhost:3000" + res.related_products[j].images[0].medium.url;
        }
      }
      if (res)
        return {
          title: res.product.title,
          hashid: res.product.hashid,
          subTitle: res.product.sub_title,
          description: res.product.description,
          price: parseFloat(Number(res.product.price) * (1 - Number(res.product.discount))).toFixed(0),
          originalPrice: res.product.price,
          quantity: res.product.quantity,
          images: tmp_images,
          isAvailable: res.product.is_available,
          reviewList: res.product.reviews,
          avgRate: Number(res.avg_rate),
          discount: Number(res.product.discount),
          relatedProducts: res.related_products,
          isFav: res.is_fav
        };
    });
  },
  methods: {
    ...mapActions(['addToCart']),
    reviewProduct () {
      if (this.$auth.loggedIn) {
        this.$axios.$post('api/reviews', {
          product_id: this.hashid,
          user_id: this.$auth.user.hashid,
          comment: this.comment,
          rate: this.rate
        }).then((res) => {
          if (res.code === "error") {
            this.$toast.error(res.message);
          } else {
            this.$toast.show(res.message);
            this.comment = '';
            this.rate = 0;
            this.$axios.$get(`api/reviews/find_by_product_id/${this.hashid}`).then((res) => {
              this.reviewList = res.reviews
            });
          }
        });
      } else {
        this.reviewAlert = true;
      }
    }
  }
};
</script>