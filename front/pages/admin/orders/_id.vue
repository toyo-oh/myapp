<template>
  <div>
    <v-alert v-model="alertCancel" type="success" close-text="Close Alert" dismissible>
      I'm a success alert.
    </v-alert>
    <v-alert v-model="alertShip" type="success" close-text="Close Alert" dismissible>
      I'm a success alert.
    </v-alert>
    <h1>{{display_order_status}}</h1>
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
    <v-btn v-if="display_cancel_btn" color="error" dark large @click="showCancelDialog()">Cancel Order</v-btn>
    <v-btn v-if="display_ship_btn" color="error" dark large @click="shipOrder">Ship</v-btn>
    <v-dialog v-model="dialogCancel" max-width="200px">
      <v-card>
        <v-card-title>Cancel Order</v-card-title>
        <v-card-text>Are you sure to cancel the order?</v-card-text>
        <v-spacer></v-spacer>
        <v-card-actions>
          <v-btn color="green darken-1" text @click="cancelOrder()">OK</v-btn>
          <v-btn color="green darken-1" text @click="dialogCancel = false">Cancel</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
export default {
  data () {
    return {
      products: [],
      totalPrice: 0,
      order_id: '',
      address_id: '',
      address_detail: '',
      order_status: '',
      alertCancel: false,
      alertShip: false,
      dialogCancel: false
    };
  },
  computed: {
    display_cancel_btn: function () {
      return this.order_status == 'order_placed' || this.order_status == 'paid' ? true : false
    },
    display_ship_btn: function () {
      return this.order_status == 'paid' ? true : false
    },
    display_order_status: function () {
      return this.order_status;
    }
  },
  asyncData ({ $axios, params }) {
    return $axios.get(`api/admin/orders/${params.id}`).then((res) => {
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
        order_id: params.id,
        order_status: res.data.order.aasm_state
      };
    });
  },
  methods: {
    showCancelDialog () {
      this.dialogCancel = !this.dialogCancel
    },
    cancelOrder () {
      this.$axios.delete(`api/admin/orders/${this.order_id}`).then((res) => {
        this.order_status = res.data.aasm_state;
        this.dialogCancel = false;
        this.alertCancel = true;
      });
    },
    shipOrder () {
      this.$axios.post(`api/admin/orders/ship_order`, { id: this.order_id }).then((res) => {
        this.order_status = res.data.aasm_state;
        this.alertShip = true;
      });
    }
  },
};
</script>