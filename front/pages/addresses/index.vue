<template>
  <div>
    <div class="d-flex justify-space-between flex-wrap mb-5">
      <div class="d-flex align-center ">
        <v-avatar tile size="25" class="me-3">
          <v-icon> mdi-map-marker</v-icon>
        </v-avatar>
        <h2 class="mb-0 brown--text text--darken-3">My Addresses</h2>
      </div>
      <v-btn outlined color="brown lighten-1" class="text-capitalize" @click="newAddress">
        Add New Address
      </v-btn>
    </div>
    <v-container>
      <v-row>
        <v-col cols="12">
          <v-data-iterator :items="addresses" :items-per-page.sync="itemsPerPage" :page.sync="page" hide-default-footer>
            <template v-slot:default="props">
              <v-row>
                <v-col v-for="item in props.items" :key="item.name" cols="12" sm="6" md="4" lg="4" xl="3">
                  <v-card class="vendor-card ">
                    <div class="ma-4">
                      <div class="d-flex justify-space-between">
                        <h3 class="ma-4">{{ item.receiver}}</h3>
                        <v-chip v-if="item.is_default" dark small class="ma-4 font-weight-medium" color="brown lighten-1">
                          DEFAULT
                        </v-chip>
                      </div>
                      <div class="d-flex mb-2 ml-3">
                        <span class="">{{"〒 "+item.post_code}}</span>
                      </div>
                      <div class="d-flex mb-2 ml-3">
                        <v-icon small class="mr-2" color="grey darken-2">mdi-map-marker</v-icon>
                        <span class="">{{item.detail_address}}</span>
                      </div>
                      <div class="d-flex mb-2 ml-3">
                        <v-icon small class="mr-2" color="grey darken-2">mdi-phone</v-icon>
                        <span class="">{{item.phone_number}}</span>
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
                        <v-btn icon color="brown" @click="editAddress(item)">
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
      <v-pagination color="brown lighten-1" v-model="page" :length="pageCount"></v-pagination>
    </div>
    <v-dialog v-model="dialogDelete" max-width="200px">
      <v-card>
        <v-card-title>Delete</v-card-title>
        <v-card-text>Are you sure to delete the address?</v-card-text>
        <v-spacer></v-spacer>
        <v-card-actions>
          <v-btn color="brown lighten-1" text @click="deleteAddress()">OK</v-btn>
          <v-btn color="brown lighten-1" text @click="dialogDelete = false">Cancel</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
export default {
  middleware: 'auth',
  data () {
    return {
      page: 1,
      pageCount: 0,
      itemsPerPage: 10,
      addresses: [],
      dialogDelete: false,
      itemToDelete: '',
      defaultId: ''
    };
  },
  created () {
    this.getAddresses();
  },
  methods: {
    getAddresses () {
      this.$axios.get(`api/addresses/find_by_user_id/${this.$auth.user.id}`).then((res) => {
        this.addresses = res.data;
        this.pageCount = Math.ceil(res.data.length / this.itemsPerPage);
        for (var n = 0; n < this.addresses.length; n++) {
          if (this.addresses[n].is_default == 1) {
            this.defaultId = this.addresses[n].id;
            break;
          }
        }
      });
    },
    editAddress (item) {
      this.$router.push(`addresses/${item.id}`)
    },
    showDeleteDialog (item) {
      this.itemToDelete = item
      this.dialogDelete = !this.dialogDelete
    },
    deleteAddress () {
      this.$axios
        .delete(`api/addresses/${this.itemToDelete.id}`)
        .then((res) => {
          this.getAddresses();
        });
      this.dialogDelete = false
    },
    setDefault (item) {
      this.$axios
        .post(`api/addresses/set_default`,
          { user_id: this.$auth.user.id, old_id: this.defaultId, id: item.id })
        .then((res) => {
          this.getAddresses();
        });
    },
    newAddress () {
      this.$router.push(`addresses/new`)
    }
  },
};
</script>