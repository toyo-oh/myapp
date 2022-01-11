<template>
  <div>
    <v-alert v-model="alertNoAddress" type="error" close-text="Close Alert" dismissible>
      I'm a warning alert(NO ADDRESS).
    </v-alert>
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
    {{$store.getters['getTotalPrice']}}
    <v-spacer></v-spacer>
    <h3>Address</h3>
    {{display_address}}
    <v-dialog v-model="dialog" scrollable max-width="500px">
      <template v-slot:activator="{ on, attrs }">
        <v-btn color="primary" dark v-bind="attrs" v-on="on" @click="getAddressList">
          Change Address
        </v-btn>
      </template>
      <v-card>
        <v-card-title>Select Address</v-card-title>
        <v-divider></v-divider>
        <v-card-text style="height: 300px;">
          <!-- The v-model property of <v-radio-group> contains the value of the selected <v-radio> -->
          <v-radio-group v-model="selectedAddressId" column>
            <v-radio v-for="(item, index) in addressList" color="indigo" :key="index" :label='item.receiver + " " + item.phone_number
          + " " + item.post_code + " " + item.detail_address' :value="item.id"></v-radio>
          </v-radio-group>
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions>
          <v-btn color="blue darken-1" text @click="dialog = false">
            Close
          </v-btn>
          <v-btn color="blue darken-1" text @click="chooseAddress">
            Ok
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-spacer></v-spacer>
    <v-btn color="error" dark large @click="createOrder">Create Order</v-btn>
  </div>
</template>

<script>
export default {
  middleware: 'auth',
  data () {
    return {
      products: [],
      totalPrice: '',
      address_id: '',
      address_detail: '',
      dialog: false,
      addressList: [],
      selectedAddressId: '',
      alertNoAddress: false
    };
  },
  created () {
    this.getProductList();
  },
  computed: {
    display_address: function () {
      return this.address_detail;
    }
  },
  methods: {
    getProductList () {
      this.$axios.get(`api/cart/get_checkout_info/${this.$auth.user.id}`).then((res) => {
        var cart_items = res.data.cart_items;
        for (var m = 0; m < cart_items.length; m++) {
          var product = {};
          product.title = cart_items[m].product.title;
          product.price = cart_items[m].price;
          product.cnt = cart_items[m].quantity;
          // TODO baseURL
          product.image = "http://localhost:3000" + cart_items[m].product.image.thumb.url;
          // this.products[m].image = this.$axios.baseURL + this.products[m].image.thumb.url;
          this.products.push(product);
        }
        if (res.data.address.length > 0) {
          var default_address = res.data.address[0];
          this.address_detail = default_address.receiver + " " + default_address.phone_number
            + " " + default_address.post_code + " " + default_address.detail_address;
          this.address_id = default_address.id;
        }
      });
    },
    getAddressList () {
      this.$axios.get(`api/addresses/find_by_user_id/${this.$auth.user.id}`).then((res) => {
        this.addressList = res.data;
      });
    },
    chooseAddress () {
      this.dialog = false;
      for (var m = 0; m < this.addressList.length; m++) {
        if (this.addressList[m].id == this.selectedAddressId) {
          this.address_detail = this.addressList[m].receiver + " " + this.addressList[m].phone_number
            + " " + this.addressList[m].post_code + " " + this.addressList[m].detail_address;
          this.address_id = this.selectedAddressId;
          break;
        }
      }
    },
    createOrder () {
      if (!this.$auth.user.id) {
        this.$router.push(`/login`)
      } else if (!this.address_id) {
        this.alertNoAddress = true;
      } else {
        const formData = new FormData();
        formData.append("user_id", this.$auth.user.id);
        formData.append("address_id", this.address_id);
        this.$axios.post("/api/order/create_order", formData).then((res) => {
          this.$router.push(`/orders/${res.data.order_id}`);
          this.$store.commit('clear_cart');
        });
      }
    }
  },
};
</script>