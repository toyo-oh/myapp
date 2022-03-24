<template>
  <div>
    <div class="d-flex justify-space-between flex-wrap mb-5">
      <div class="d-flex align-center ">
        <v-avatar tile size="25" class="me-3">
          <v-icon>mdi-shopping</v-icon>
        </v-avatar>
        <h2 class="mb-0 brown--text text--darken-3">My Orders</h2>
      </div>
    </div>
    <v-data-iterator :items="orders" :page.sync="page" :items-per-page="itemsPerPage" hide-default-footer>
      <template v-slot:default="{ items }">
        <list-card v-for="item in items" :key="item.order_no" :order="item" :details="item.details"></list-card>
      </template>
    </v-data-iterator>
    <div class="text-center pt-2">
      <v-pagination color="brown lighten-1" v-model="page" :length="pageCount"></v-pagination>
    </div>
  </div>
</template>

<script>
import ListCard from '@/components/OrderCard/ListCard.vue';
export default {
  middleware: 'auth',
  components: {
    ListCard
  },
  data () {
    return {
      page: 1,
      pageCount: 0,
      itemsPerPage: 5,
      orders: [],
    };
  },
  created () {
    this.getOrders();
  },
  methods: {
    getOrders () {
      this.$axios.get(`api/orders/get_orders_by_user_id/${this.$auth.user.hashid}`).then((res) => {
        this.orders = [];
        var tmpOrders = res.data.orders;
        for (var m = 0; m < tmpOrders.length; m++) {
          var order = {};
          order.order_no = tmpOrders[m].order_no;
          order.createdAt = tmpOrders[m].created_at;
          order.amountTotal = tmpOrders[m].amount_total;
          order.orderStatus = tmpOrders[m].aasm_state;
          order.shippingFee = tmpOrders[m].shipping_fee;
          order.details = tmpOrders[m].order_details;
          for (var n = 0; n < order.details.length; n++) {
            order.details[n].image = "http://localhost:3000" + order.details[n].image
          }
          this.orders.push(order);
        }
        this.pageCount = Math.ceil(res.data.orders.length / this.itemsPerPage);
      });
    }
  },
};
</script>