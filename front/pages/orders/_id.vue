<template>
  <div>
    <v-simple-table>
      <template v-slot:default>
        <thead>
          <tr>
            <th></th>
            <th>Title</th>
            <th>Price</th>
            <th>Count</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in products" :key="item.id">
            <td>
              <router-link :to="{name: 'products-id', params: {id: item.id}}">
                <img :src="item.image" max-height="100" max-width="100">
              </router-link>
            </td>
            <td>{{ item.title }}</td>
            <td>{{ item.price }}</td>
            <td>{{ item.cnt }}</td>
          </tr>
        </tbody>
      </template>
    </v-simple-table>
    <v-spacer></v-spacer>
    <h3>Total</h3>
    {{totalPrice}}
    <v-spacer></v-spacer>
    <h3>Address</h3>
    {{address_detail}}
    <v-spacer></v-spacer>
    <v-btn v-if="display_pay_btn" color="error" dark large @click="payOrder">Pay Order</v-btn>
  </div>
</template>

<script>
export default {
  data () {
    return {
      products: [],
      totalPrice: 0,
      address_id: '',
      address_detail: '',
      display_pay_btn: false
    };
  },
  asyncData ({ $axios, params }) {
    return $axios.get(`api/orders/${params.id}`).then((res) => {
      var order_items = res.data.order_details;
      var tmp_products = [];
      var tmp_total = 0;
      for (var m = 0; m < order_items.length; m++) {
        var product = {};
        product.title = order_items[m].product_title;
        product.price = order_items[m].price;
        product.cnt = order_items[m].quantity;
        // TODO baseURL
        product.image = "http://localhost:3000" + order_items[m].product.image.thumb.url;
        // this.products[m].image = this.$axios.baseURL + this.products[m].image.thumb.url;
        tmp_products.push(product);
        tmp_total += order_items[m].subtotal;
      }
      return {
        address_detail: res.data.address.receiver + " " + res.data.address.phone_number
          + " " + res.data.address.post_code + " " + res.data.address.detail_address,
        address_id: res.data.address.id,
        products: tmp_products,
        totalPrice: tmp_total,
        display_pay_btn: res.data.order.is_paid ? false : true
      };
    });
  },
  methods: {
    payOrder () {
    }
  },
};
</script>