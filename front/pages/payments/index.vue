<template>
  <div>
    <div class="d-flex justify-space-between flex-wrap mb-5">
      <div class="d-flex align-center">
        <v-avatar tile size="25" class="me-3">
          <v-icon> mdi-credit-card</v-icon>
        </v-avatar>
        <h2 class="mb-0 brown--text text--darken-3">My Payments</h2>
      </div>
      <v-btn outlined color="brown lighten-1" class="text-capitalize" @click="newPayment">
        Add New Payment
      </v-btn>
    </div>
    <v-container>
      <v-row>
        <v-col cols="12">
          <v-data-iterator
            :items="payments"
            :items-per-page.sync="itemsPerPage"
            :page.sync="page"
            hide-default-footer>
            <template #default="props">
              <v-row>
                <v-col v-for="item in props.items" :key="item.name" cols="4">
                  <v-card>
                    <div class="ma-4">
                      <div class="d-flex justify-space-between">
                        <h3 class="ma-4">{{ item.holder_name }}</h3>
                        <v-chip
                          v-if="item.is_default"
                          dark
                          small
                          class="ma-4 font-weight-medium"
                          color="brown lighten-1">
                          DEFAULT
                        </v-chip>
                      </div>
                      <div class="d-flex mb-2 ml-3">
                        <span class=""
                          >**** **** **** {{ item.card_number.substring(12, 16) }}</span
                        >
                      </div>
                      <div class="d-flex mb-2 ml-3">
                        <!-- <v-icon small class="mr-2" color="grey darken-2">mdi-map-marker</v-icon> -->
                        <span class="">{{
                          item.expiration_date.substring(0, 4) +
                          "/" +
                          item.expiration_date.substring(4, 6)
                        }}</span>
                      </div>
                    </div>
                    <v-card-actions class="d-flex justify-end align-center">
                      <div class="mr-3">
                        <v-btn v-if="!item.is_default" text color="brown" @click="setDefault(item)">
                          <div>Default</div>
                        </v-btn>
                        <v-btn icon color="brown" @click="showDeleteDialog(item)">
                          <v-icon>mdi-close</v-icon>
                        </v-btn>
                        <v-btn icon color="brown" @click="editPayment(item)">
                          <v-icon>mdi-arrow-right</v-icon>
                        </v-btn>
                      </div>
                    </v-card-actions>
                  </v-card>
                </v-col>
              </v-row>
            </template>
          </v-data-iterator>
        </v-col>
      </v-row>
    </v-container>
    <div class="text-center pt-2">
      <v-pagination v-model="page" color="brown lighten-1" :length="pageCount"></v-pagination>
    </div>
    <v-dialog v-model="dialogDelete" max-width="200px">
      <v-card>
        <v-card-title>Delete</v-card-title>
        <v-card-text>Are you sure to delete the Payment?</v-card-text>
        <v-spacer></v-spacer>
        <v-card-actions>
          <v-btn color="brown lighten-1" text @click="deletePayment()">OK</v-btn>
          <v-btn color="brown lighten-1" text @click="dialogDelete = false">Cancel</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
export default {
  middleware: "auth",
  data() {
    return {
      page: 1,
      pageCount: 0,
      itemsPerPage: 10,
      payments: [],
      dialogDelete: false,
      itemToDelete: "",
      defaultId: "",
    }
  },
  created() {
    this.getPayments()
  },
  methods: {
    getPayments() {
      this.$axios.get(`api/payments/find_by_user_id/${this.$auth.user.hashid}`).then((res) => {
        this.payments = res.data.payments
        this.pageCount = Math.ceil(this.payments.length / this.itemsPerPage)
        for (var n = 0; n < this.payments.length; n++) {
          if (this.payments[n].is_default == 1) {
            this.defaultId = this.payments[n].hashid
            break
          }
        }
      })
    },
    editPayment(item) {
      this.$router.push(`payments/${item.hashid}`)
    },
    showDeleteDialog(item) {
      this.itemToDelete = item
      this.dialogDelete = !this.dialogDelete
    },
    deletePayment() {
      this.$axios.delete(`api/payments/${this.itemToDelete.hashid}`).then(() => {
        this.getPayments()
        this.$toast.show("Delete payment successfully!")
      })
      this.dialogDelete = false
    },
    setDefault(item) {
      this.$axios
        .post(`api/payments/set_default`, {
          user_id: this.$auth.user.hashid,
          old_id: this.defaultId,
          id: item.hashid,
        })
        .then(() => {
          this.getPayments()
          this.$toast.show("Set default payment successfully!")
        })
    },
    newPayment() {
      this.$router.push(`payments/new`)
    },
  },
}
</script>
