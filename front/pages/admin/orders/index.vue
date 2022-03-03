<template>
  <div>
    <div class="d-flex justify-space-between flex-wrap mb-5">
      <div class="d-flex align-center ">
        <v-avatar tile size="25" class="me-3">
          <v-icon>mdi-shopping</v-icon>
        </v-avatar>
        <h2 class="mb-0">Order List</h2>
      </div>
    </div>
    <v-data-table :headers="headers" :items="orders" :page.sync="page" :items-per-page="itemsPerPage" hide-default-footer>
      <template v-slot:item.id="{ item }">
        <h4 class="mb-0">{{item.id}}</h4>
      </template>
      <template v-slot:item.aasmState="{ item }">
        <v-chip class="ma-2" color="grey lighten-2" small>
          {{item.aasmState}}
        </v-chip>
      </template>
      <template v-slot:item.shortDetails="{ item }">
        <div v-html="item.shortDetails" />
      </template>
      <template v-slot:item.createdAt="{ item }">
        <span>{{ new Date(item.createdAt).toLocaleString("ja-jp") }}</span>
      </template>
      <template v-slot:item.amountTotal="{ item }">
        ¥{{item.amountTotal}}
      </template>
      <template v-slot:item.detail="{ item }">
        <v-btn small outlined color="brown lighten-1" class="mr-2" @click="getOrderDetail(item)">Detail</v-btn>
      </template>
    </v-data-table>
    <div class="text-center pt-2">
      <v-pagination color="brown lighten-1" v-model="page" :length="pageCount"></v-pagination>
    </div>
  </div>
</template>

<script>
export default {
  middleware: ['auth', 'admin'],
  data () {
    return {
      page: 1,
      pageCount: 0,
      itemsPerPage: 9,
      headers: [
        { text: "Order ID", align: "start", sortable: false, value: "id", class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
        { text: "Status", value: "aasmState", sortable: false, class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
        { text: "ShortDetails", value: "shortDetails", sortable: false, class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
        { text: "CreateTime", value: "createdAt", sortable: false, class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
        { text: "Total", value: "amountTotal", sortable: false, class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
        { text: "Detail", value: "detail", sortable: false, class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
      ],
      orders: [],
      dialogDelete: false,
      itemToDelete: '',
    };
  },
  created () {
    this.getOrders();
  },
  methods: {
    getOrders () {
      this.$axios.get(`api/admin/orders`).then((res) => {
        var tmpOrders = res.data.orders;
        this.orders = [];
        for (var m = 0; m < tmpOrders.length; m++) {
          var order = {};
          order.id = tmpOrders[m].id;
          order.createdAt = tmpOrders[m].created_at;
          order.amountTotal = tmpOrders[m].amount_total;
          order.aasmState = tmpOrders[m].aasm_state;
          order.shortDetails = "";
          for (var n = 0; n < tmpOrders[m].order_details.length; n++) {
            order.shortDetails += (tmpOrders[m].order_details[n].product_title + "<br/>")
          }
          this.orders.push(order);
        }
        this.pageCount = Math.ceil(res.data.orders.length / this.itemsPerPage);
      });
    },
    getOrderDetail (item) {
      this.$router.push(`/admin/orders/${item.id}`)
    },
  },
};
</script>