
<template>
  <div>
    <v-alert v-model="alertDelete" border="left" close-text="Close Alert" color="deep-purple accent-4" dark dismissible>
      This order can not be deleted!
    </v-alert>
    <v-data-table :headers="headers" :items="orders">
      <template v-slot:item.short_details="{ item }">
        <div v-html="item.short_details" />
      </template>
      <template v-slot:item.created_at="{ item }">
        <span>{{ new Date(item.created_at).toLocaleString("ja-jp") }}</span>
      </template>
      <template v-slot:item.detail="{ item }">
        <v-btn small class="mr-2" @click="getOrderDetail(item)">Detail</v-btn>
      </template>
    </v-data-table>
  </div>
</template>

<script>
export default {
  data () {
    return {
      headers: [
        { text: "ID", align: "start", sortable: false, value: "id" },
        { text: "ShortDetails", value: "short_details" },
        { text: "CreateTime", value: "created_at" },
        { text: "Total", value: "amount_total" },
        { text: "Status", value: "aasm_state" },
        { text: "Detail", value: "detail", sortable: false },
      ],
      orders: [],
      dialogDelete: false,
      itemToDelete: '',
      alertDelete: false
    };
  },
  // TODO 变为asyncData方法获取初始数据
  created () {
    this.getOrders();
  },
  methods: {
    getOrders () {
      this.$axios.get(`api/admin/orders`).then((res) => {
        var tmp_orders = res.data.orders;
        this.orders = [];
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
      });
    },
    getOrderDetail (item) {
      this.$router.push(`/admin/orders/${item.id}`)
    },
  },
};
</script>