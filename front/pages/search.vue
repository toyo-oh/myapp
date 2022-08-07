<template>
  <v-container class="mt-6">
    <v-row>
      <v-col cols="12">
        <v-card>
          <v-card-text class="ps-6 d-flex justify-space-between align-center flex-wrap">
            <div class="my-2">
              <h4 class="">Searching for "{{ value }}"</h4>
              <p class="gray--text text--darken-1 mb-0">{{ items.length }} results found</p>
            </div>
            <div class="d-flex align-center flex-wrap">
              <div class="grey--text text--darken-1 me-2 my-2">Sort by :</div>
              <v-select
                v-model="sortSelected"
                color="brown lighten-1"
                class="border me-5"
                :items="sortItems"
                label="Price"
                dense
                outlined
                hide-details
                flat
                @change="sort('price')"></v-select>
            </div>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12">
        <div>
          <div>
            <div>
              <v-row>
                <v-col cols="12">
                  <v-data-iterator
                    :items="items"
                    :items-per-page.sync="itemsPerPage"
                    :page.sync="page"
                    hide-default-footer>
                    <template #default="props">
                      <v-row>
                        <v-col v-for="(item, index) in props.items" :key="index" cols="3">
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
  data() {
    return {
      page: 1,
      itemsPerPage: 12,
      range: [0, 100, 500, 1000],
      sortItems: ["Low to High", "High to Low"],
      sortSelected: "",
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
  watch: {
    $route() {
      this.searchProducts()
    },
  },
  created() {
    this.searchProducts()
  },
  methods: {
    ...mapActions(["addToCart"]),
    searchProducts() {
      this.$axios.$post(`/api/products/search`, { value: this.$route.query.value }).then((res) => {
        var products = res.products
        for (var m = 0; m < products.length; m++) {
          products[m].qty = 1
        }
        this.items = products
        this.value = this.$route.query.value
      })
    },
    sort(price) {
      if (this.sortSelected == "Low to High") {
        this.items = this.items.sort((a, b) => (a[price] < b[price] ? -1 : 1))
      } else {
        this.items = this.items.sort((a, b) => (a[price] > b[price] ? -1 : 1))
      }
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
