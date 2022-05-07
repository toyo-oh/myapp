<template>
  <div>
    <div class="d-flex justify-space-between flex-wrap mb-5">
      <div class="d-flex align-center">
        <v-avatar tile size="25" class="me-3">
          <v-icon>mdi-shopping</v-icon>
        </v-avatar>
        <h2 class="mb-0">Order List</h2>
      </div>
    </div>
    <div class="mb-5">
      <v-card>
        <v-card-title>
          <v-text-field
            v-model="noSearch"
            class="mr-6"
            color="brown lighten-3"
            outlined
            dense
            append-icon="mdi-magnify"
            label="Order No"
            clearable
            hide-details
            @change="filter"></v-text-field>
          <v-select
            v-model="stsSearch"
            class="mr-6"
            color="brown lighten-3"
            item-color="brown lighten-1"
            outlined
            dense
            :items="orderStsList"
            item-text="status"
            item-value="value"
            label="Order Status"
            hide-details
            @change="filter"></v-select>
          <v-select
            v-model="crtAtSearch"
            class="mr-6"
            color="brown lighten-3"
            item-color="brown lighten-1"
            outlined
            dense
            :items="createdAtList"
            item-text="createdAt"
            item-value="date"
            label="Created At"
            hide-details
            @change="filter"></v-select>
        </v-card-title>
      </v-card>
    </div>
    <v-data-table
      :headers="headers"
      :items="filteredOrders"
      :page.sync="page"
      :items-per-page="itemsPerPage"
      hide-default-footer>
      <template #[`item.orderNo`]="{ item }">
        <h5 class="mb-0">{{ item.orderNo }}</h5>
      </template>
      <template #[`item.aasmState`]="{ item }">
        <v-chip class="ma-2" color="grey lighten-2" small>
          {{ item.aasmState }}
        </v-chip>
      </template>
      <template #[`item.shortDetails`]="{ item }">
        <!-- eslint-disable-next-line vue/no-v-html -->
        <div v-html="item.shortDetails" />
      </template>
      <template #[`item.createdAt`]="{ item }">
        <span>{{ new Date(item.createdAt).toLocaleString("ja-jp") }}</span>
      </template>
      <template #[`item.amountTotal`]="{ item }"> ¥{{ item.amountTotal }} </template>
      <template #[`item.detail`]="{ item }">
        <v-btn small outlined color="brown lighten-1" class="mr-2" @click="getOrderDetail(item)"
          >Detail</v-btn
        >
      </template>
    </v-data-table>
    <div class="text-center pt-2">
      <v-pagination v-model="page" color="brown lighten-1" :length="pageCount"></v-pagination>
    </div>
  </div>
</template>

<script>
import dayjs from "dayjs"
export default {
  middleware: ["auth", "admin"],
  data() {
    return {
      page: 1,
      pageCount: 0,
      itemsPerPage: 10,
      headers: [
        {
          text: "Order NO",
          align: "start",
          sortable: false,
          value: "orderNo",
          class: "text-h6 grey--text text--darken-2 flex-1 mr-3",
        },
        {
          text: "Status",
          value: "aasmState",
          sortable: false,
          class: "text-h6 grey--text text--darken-2 flex-1 mr-3",
        },
        {
          text: "ShortDetails",
          value: "shortDetails",
          sortable: false,
          class: "text-h6 grey--text text--darken-2 flex-1 mr-3",
        },
        {
          text: "CreateTime",
          value: "createdAt",
          sortable: false,
          class: "text-h6 grey--text text--darken-2 flex-1 mr-3",
        },
        {
          text: "Total",
          value: "amountTotal",
          sortable: false,
          class: "text-h6 grey--text text--darken-2 flex-1 mr-3",
        },
        {
          text: "Detail",
          value: "detail",
          sortable: false,
          class: "text-h6 grey--text text--darken-2 flex-1 mr-3",
        },
      ],
      dialogDelete: false,
      itemToDelete: "",
      orders: [],
      filteredOrders: [],
      noSearch: "",
      stsSearch: "",
      crtAtSearch: "",
      orderStsList: [
        { status: "all", value: "" },
        { status: "order_placed", value: "order_placed" },
        { status: "paid", value: "paid" },
        { status: "shipping", value: "shipping" },
        { status: "delivered", value: "delivered" },
        { status: "order_cancelled", value: "order_cancelled" },
      ],
      createdAtList: [
        { createdAt: "all", date: "" },
        { createdAt: "today", date: dayjs().format("YYYY/MM/DD") },
        {
          createdAt: "this week",
          date: dayjs().subtract(1, "week").format("YYYY/MM/DD"),
        },
        {
          createdAt: "this month",
          date: dayjs().subtract(1, "month").format("YYYY/MM/DD"),
        },
        {
          createdAt: "3 months",
          date: dayjs().subtract(3, "month").format("YYYY/MM/DD"),
        },
        {
          createdAt: "half year",
          date: dayjs().subtract(6, "month").format("YYYY/MM/DD"),
        },
      ],
    }
  },
  created() {
    this.getOrders()
  },
  methods: {
    getOrders() {
      this.$axios.get(`api/admin/orders`).then((res) => {
        var tmpOrders = res.data.orders
        this.orders = []
        for (var m = 0; m < tmpOrders.length; m++) {
          var order = {}
          order.orderNo = tmpOrders[m].order_no
          order.createdAt = tmpOrders[m].created_at
          order.amountTotal = tmpOrders[m].amount_total
          order.aasmState = tmpOrders[m].aasm_state
          order.shortDetails = ""
          for (var n = 0; n < tmpOrders[m].order_details.length; n++) {
            order.shortDetails += tmpOrders[m].order_details[n].product_title + "<br/>"
          }
          this.orders.push(order)
        }
        this.filteredOrders = this.orders
        this.pageCount = Math.ceil(this.filteredOrders.length / this.itemsPerPage)
      })
    },
    getOrderDetail(item) {
      this.$router.push(`/admin/orders/${item.orderNo}`)
    },
    filter() {
      this.filteredOrders = this.orders
      if (this.noSearch != null && this.noSearch.trim() != "") {
        this.filteredOrders = this.filteredOrders.filter((item) =>
          item.orderNo == this.noSearch.trim() ? true : false
        )
      }
      if (this.stsSearch != "") {
        this.filteredOrders = this.filteredOrders.filter((item) =>
          item.aasmState == this.stsSearch ? true : false
        )
      }
      if (this.crtAtSearch != "") {
        this.filteredOrders = this.filteredOrders.filter((item) =>
          dayjs(item.createdAt).format("YYYY/MM/DD") >= this.crtAtSearch ? true : false
        )
      }
      this.pageCount = Math.ceil(this.filteredOrders.length / this.itemsPerPage)
    },
  },
}
</script>
