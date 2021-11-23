<template>
  <div>
    <v-row justify="center" align="center">
      <v-col cols="6">
        <v-img :src="image" max-height="400" max-width="400"></v-img>
      </v-col>
      <v-col cols="6">
        <v-row>
          <h2>{{title}}</h2>
        </v-row>
        <v-row>
          <h4>{{description}}</h4>
        </v-row>
        <v-row>Price:{{price}}</v-row>
        <v-row>Quantity:{{quantity}}</v-row>
        <v-row>
          <v-btn color="error" dark large @click="addToCart">Add To Cart</v-btn>
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
      description: '',
      price: '',
      quantity: '',
      image: ''
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
          console.log(res);
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