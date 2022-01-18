<template>
  <div>
    <v-row justify="center" align="center">
      <v-col cols="5">
        <v-img :src="image" max-height="350" max-width="350"></v-img>
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
          <v-btn x-large dark width="250" @click="addToCart" color="brown lighten-1" class="text-capitalize mb-3" :class="btn_class">
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
      image: ''
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
      return {
        id: res.id,
        title: res.title,
        description: res.description,
        price: res.price,
        quantity: res.quantity,
        image: "http://localhost:3000" + res.image.medium.url
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