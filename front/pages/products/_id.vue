<template>
  <div>
    <v-row justify="center" align="center">
      <v-col cols="5">
        <v-sheet max-width="400" max-height="400" class="mx-auto">
          <v-carousel height="400" light hide-delimiter-background>
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
          <p class="grey--text text--grey-lighten-1 me-3 mb-0">Description:</p>
          <p class="mb-0">{{description}}</p>
        </div>
        <div class="d-flex mb-4">
          <p class="grey--text text--grey-lighten-1 me-3 mb-0">Rated:</p>
          <div class="d-flex align-center justify-center align-center mb-1">
            <v-rating :value="4.5" color="amber" dense half-increments readonly size="16"></v-rating>
            <div class="grey--text text--darken-4 ml-1">
              (4.5)
            </div>
          </div>
        </div>
        <div class="d-flex mb-4">
          <p class="grey--text text--grey-lighten-1 me-3 mb-0">Quantity:</p>
          <p class="mb-0">{{quantity}}</p>
        </div>
        <div class="mb-6">
          <h2 class="brown--text text--darken-3">¥{{price}}</h2>
          <p class="">Stock Available</p>
        </div>
        <div class="mb-6">
          <v-btn v-if="!$auth.user.is_admin" x-large dark width="250" @click="addToCart" color="brown lighten-1" class="text-capitalize mb-3" :class="btn_class">
            Add to Cart
          </v-btn>
        </div>
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
      description: '',
      price: '',
      quantity: '',
      images: []
    }
  },
  computed: {
    btn_class () {
      return {
        btn_class: this.quantity <= 0 ? 'd-block' : 'd-none'
      }
    }
  },
  asyncData ({ $axios, params }) {
    return $axios.$get(`/api/products/${params.id}`).then((res) => {
      var tmp_images = [];
      if (res.images) {
        for (var i = 0; i < res.images.length; i++) {
          tmp_images.push(res.images[i] ? "http://localhost:3000" + res.images[i].medium.url : "");
        }
      }
      return {
        id: res.id,
        title: res.title,
        description: res.description,
        price: res.price,
        quantity: res.quantity,
        images: tmp_images
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
    // TODO 收藏功能
    addToFavorite () {
    }
  }
};
</script>