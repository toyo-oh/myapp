<template>
  <v-container class="mt-6">
    <v-row>
      <v-col cols="12">
        <div class="box-wrapper">
          <div
            class="box-overlay"
            :class="{ open: isSidebar }"
            @click="isSidebar = !isSidebar"></div>
          <div class="box-content">
            <div class="d-flex justify-end pa-2 d-block d-md-none">
              <v-btn icon @click="isSidebar = !isSidebar">
                <v-icon dark> mdi-format-list-bulleted-square </v-icon>
              </v-btn>
            </div>
            <div class="box-container">
              <v-row>
                <v-col cols="12">
                  <v-data-iterator
                    :items="items"
                    :items-per-page.sync="itemsPerPage"
                    :page.sync="page"
                    hide-default-footer>
                    <template #default="props">
                      <v-row>
                        <v-col
                          v-for="(item, index) in props.items"
                          :key="index"
                          cols="12"
                          sm="6"
                          md="6"
                          lg="3"
                          xl="3">
                          <item-card
                            :p-hash-id="item.hashid"
                            :p-img="item.images[0].medium.url"
                            :p-title="item.title"
                            :original-price="item.price"
                            :sub-title="item.sub_title"
                            :p-discount="Number(item.discount)"
                            @cartAdd="
                              addToCart({
                                hashid: item.hashid,
                                price: parseFloat(
                                  Number(item.price) * (1 - Number(item.discount))
                                ).toFixed(0),
                              })
                            ">
                          </item-card>
                        </v-col>
                      </v-row>
                    </template>
                    <template #footer>
                      <v-row class="my-5 me-1" align="center" justify="center">
                        <v-spacer></v-spacer>
                        <span class="mr-4 grey--text">
                          Page {{ page }} of {{ numberOfPages }}
                        </span>
                        <v-btn
                          fab
                          :disabled="page == 1"
                          small
                          color="brown lighten-1"
                          class="mr-1"
                          @click="formerPage">
                          <v-icon>mdi-chevron-left</v-icon>
                        </v-btn>
                        <v-btn
                          fab
                          :disabled="page == numberOfPages"
                          small
                          color="brown lighten-1"
                          class="ml-1"
                          @click="nextPage">
                          <v-icon>mdi-chevron-right</v-icon>
                        </v-btn>
                      </v-row>
                    </template>
                  </v-data-iterator>
                </v-col>
              </v-row>
            </div>
          </div>
        </div>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import ItemCard from "@/components/productCard/ItemCard"
import { mapActions } from "vuex"
export default {
  components: {
    ItemCard,
  },
  middleware: "auth",
  data() {
    return {
      isSidebar: false,
      page: 1,
      itemsPerPage: 8,
      selected: [],
      items: [],
      value: "",
    }
  },
  computed: {
    numberOfPages() {
      return Math.ceil(this.items.length / this.itemsPerPage)
    },
  },
  created() {
    this.loadData()
  },
  methods: {
    ...mapActions(["addToCart"]),
    loadData() {
      this.$axios
        .$get(`/api/favourites/list_favourites_by_user_id/${this.$auth.user.hashid}`)
        .then((res) => {
          var products = res.products
          for (var m = 0; m < products.length; m++) {
            products[m].qty = 1
          }
          this.items = products
        })
    },
    nextPage() {
      if (this.page + 1 <= this.numberOfPages) this.page += 1
    },
    formerPage() {
      if (this.page - 1 >= 1) this.page -= 1
    },
  },
}
</script>
