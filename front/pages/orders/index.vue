
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
      <template v-slot:item.delete="{ item }">
        <v-btn small @click="showDeleteDialog(item)">Delete</v-btn>
      </template>
    </v-data-table>
    <!-- <v-dialog v-model="dialogDelete" max-width="200px">
      <v-card>
        <v-card-title>Delete</v-card-title>
        <v-card-text>Are you sure to delete the order?</v-card-text>
        <v-spacer></v-spacer>
        <v-card-actions>
          <v-btn color="green darken-1" text @click="deleteOrder()">OK</v-btn>
          <v-btn color="green darken-1" text @click="dialogDelete = false">Cancel</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog> -->
  </div>
</template>

<script>
export default {
  middleware: 'auth',
  data () {
    return {
      headers: [
        { text: "ID", align: "start", sortable: false, value: "id" },
        { text: "ShortDetails", value: "short_details" },
        { text: "CreateTime", value: "created_at" },
        { text: "Total", value: "amount_total" },
        { text: "Status", value: "aasm_state" },
        { text: "Detail", value: "detail", sortable: false },
        // { text: "Delete", value: "delete", sortable: false },
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
        }
      });
    },
    getOrderDetail (item) {
      this.$router.push(`orders/${item.id}`)
    },
    // showDeleteDialog (item) {
    //   this.itemToDelete = item
    //   this.dialogDelete = !this.dialogDelete
    // },
    // deleteOrder () {
    //   if (this.itemToDelete.aasm_state == 'order_placed' || this.itemToDelete.aasm_state == 'paid') {
    //     this.$axios.delete(`api/orders/${this.itemToDelete.id}`).then((res) => {
    //       this.getOrders();
    //     });
    //   } else {
    //     this.alertDelete = true;
    //   }
    //   this.dialogDelete = false;
    // }
  },
};
</script>