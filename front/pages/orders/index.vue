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
    <v-data-table :headers="headers" :items="orders" :page.sync="page" :items-per-page="itemsPerPage" hide-default-footer>
      <template v-slot:item.id="{ item }">
        <h4 class="mb-0 ">{{item.id}}</h4>
      </template>
      <template v-slot:item.aasm_state="{ item }">
        <v-chip class="ma-2" color="grey lighten-2" small>
          {{item.aasm_state}}
        </v-chip>
      </template>
      <template v-slot:item.short_details="{ item }">
        <div v-html="item.short_details" />
      </template>
      <template v-slot:item.created_at="{ item }">
        <span>{{ new Date(item.created_at).toLocaleString("ja-jp") }}</span>
      </template>
      <template v-slot:item.amount_total="{ item }">
        ¥{{item.amount_total}}
      </template>
      <template v-slot:item.detail="{ item }">
        <v-btn small outlined color="brown lighten-1" class="mr-2" @click="getOrderDetail(item)">Detail</v-btn>
      </template>
      <!-- <template v-slot:item.delete="{ item }">
        <v-btn small @click="showDeleteDialog(item)">Delete</v-btn>
      </template> -->
    </v-data-table>
    <div class="text-center pt-2">
      <v-pagination color="brown lighten-1" v-model="page" :length="pageCount"></v-pagination>
    </div>
  </div>
</template>

<script>
export default {
  middleware: 'auth',
  data () {
    return {
      page: 1,
      pageCount: 0,
      itemsPerPage: 9,
      headers: [
        { text: "Order ID", align: "start", sortable: false, value: "id", class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
        { text: "Status", value: "aasm_state", sortable: false, class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
        { text: "ShortDetails", value: "short_details", sortable: false, class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
        { text: "CreateTime", value: "created_at", sortable: false, class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
        { text: "Total", value: "amount_total", sortable: false, class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
        { text: "Detail", value: "detail", sortable: false, class: "text-h6 grey--text text--darken-2 flex-1 mr-3" },
        // { text: "Delete", value: "delete", sortable: false },
      ],
      orders: [],
      dialogDelete: false,
      itemToDelete: '',
    };
  },
  // TODO 变为asyncData方法获取初始数据
  created () {
    this.getOrders();
  },
  methods: {
    getOrders () {
      this.$axios.get(`api/orders/get_orders_by_user_id/${this.$auth.user.id}`).then((res) => {
        this.orders = [];
        if (res.status == '200') {
          var tmp_orders = res.data.orders;
          for (var m = 0; m < tmp_orders.length; m++) {
            var order = {};
            order.id = tmp_orders[m].id;
            order.created_at = tmp_orders[m].created_at;
            order.amount_total = tmp_orders[m].amount_total;
            order.aasm_state = tmp_orders[m].aasm_state;
            order.short_details = "";
            for (var n = 0; n < tmp_orders[m].order_details.length; n++) {
              order.short_details += (tmp_orders[m].order_details[n].product_title + "<br/>")
            }
            this.orders.push(order);
          }
          this.pageCount = Math.ceil(res.data.orders.length / this.itemsPerPage);
        } else {
          this.pageCount = 0;
        }
      });
    },
    getOrderDetail (item) {
      this.$router.push(`orders/${item.id}`)
    }
  },
};
</script>