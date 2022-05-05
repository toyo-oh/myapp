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
    <div class="mb-5">
      <v-card>
        <v-card-title>
          <v-text-field class="mr-6" color="brown lighten-3" outlined dense v-model="noSearch" append-icon="mdi-magnify" label="Order No" @change="filter" clearable hide-details></v-text-field>
          <v-select class="mr-6" color="brown lighten-3" item-color="brown lighten-1" outlined dense :items="orderStsList" item-text="status" item-value="value" v-model="stsSearch" label="Order Status" @change="filter" hide-details></v-select>
          <v-select class="mr-6" color="brown lighten-3" item-color="brown lighten-1" outlined dense :items="createdAtList" item-text="createdAt" item-value="date" v-model="crtAtSearch" label="Created At" @change="filter" hide-details></v-select>
        </v-card-title>
      </v-card>
    </div>
    <v-data-iterator :items="filteredOrders" :page.sync="page" :items-per-page="itemsPerPage" hide-default-footer>
      <template v-slot:default="{ items }">
        <list-card v-for="item in items" :key="item.orderNo" :order="item" :details="item.details"></list-card>
      </template>
    </v-data-iterator>
    <div class="text-center pt-2">
      <v-pagination color="brown lighten-1" v-model="page" :length="pageCount"></v-pagination>
    </div>
  </div>
</template>

<script>
import dayjs from 'dayjs';
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
      filteredOrders: [],
      noSearch: '',
      stsSearch: '',
      crtAtSearch: '',
      orderStsList: [
        { status: 'all', value: '' },
        { status: 'order_placed', value: 'order_placed' },
        { status: 'paid', value: 'paid' },
        { status: 'shipping', value: 'shipping' },
        { status: 'delivered', value: 'delivered' },
        { status: 'order_cancelled', value: 'order_cancelled' }],
      createdAtList: [
        { createdAt: 'all', date: '' },
        { createdAt: 'today', date: dayjs().format('YYYY/MM/DD') },
        { createdAt: 'this week', date: dayjs().subtract(1, 'week').format('YYYY/MM/DD') },
        { createdAt: 'this month', date: dayjs().subtract(1, 'month').format('YYYY/MM/DD') },
        { createdAt: '3 months', date: dayjs().subtract(3, 'month').format('YYYY/MM/DD') },
        { createdAt: 'half year', date: dayjs().subtract(6, 'month').format('YYYY/MM/DD') }]
    };
  },
  created () {
    this.getOrders();
  },
  methods: {
    getOrders () {
      this.$axios.get(`api/orders/list_orders_by_user_id/${this.$auth.user.hashid}`).then((res) => {
        this.orders = [];
        var tmpOrders = res.data.orders;
        if (tmpOrders && tmpOrders.length > 0) {
          for (var m = 0; m < tmpOrders.length; m++) {
            var order = {};
            order.orderNo = tmpOrders[m].order_no;
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
        }
        this.filteredOrders = this.orders;
        this.pageCount = Math.ceil(this.filteredOrders.length / this.itemsPerPage);
      });
    },
    filter () {
      this.filteredOrders = this.orders;
      if (this.noSearch != null && this.noSearch.trim() != '') {
        this.filteredOrders = this.filteredOrders.filter(item =>
          item.orderNo == this.noSearch.trim() ? true : false
        );
      }
      if (this.stsSearch != '') {
        this.filteredOrders = this.filteredOrders.filter(item =>
          item.orderStatus == this.stsSearch ? true : false
        );
      }
      if (this.crtAtSearch != '') {
        this.filteredOrders = this.filteredOrders.filter(item =>
          dayjs(item.createdAt).format('YYYY/MM/DD') >= this.crtAtSearch ? true : false
        );
      }
      this.pageCount = Math.ceil(this.filteredOrders.length / this.itemsPerPage);
    }
  }
};
</script>