<template>
  <v-container class="mt-6">
    <v-row>
      <v-col cols="12">
        <v-card>
          <v-card-text class="ps-6 d-flex justify-space-between align-center flex-wrap">
            <div class="my-2">
              <h4 class="">Searching for "{{value}}"</h4>
              <p class="gray--text text--darken-1 mb-0">{{items.length}} results found</p>
            </div>
            <div class="d-flex align-center flex-wrap">
              <div class="grey--text text--darken-1 me-2 my-2">Sort by :</div>
              <v-select color="brown lighten-1" class="border me-5" :items="sortItems" label="Price" dense v-model="sortSelected" @change="sort('price')" outlined hide-details flat></v-select>
            </div>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12">
        <div class="box-wrapper">
          <div class="box-overlay" :class="{'open': isSidebar}" @click="isSidebar = !isSidebar"></div>
          <div class="box-content">
            <div class="d-flex justify-end pa-2 d-block d-md-none">
              <v-btn icon @click="isSidebar = !isSidebar">
                <v-icon dark>
                  mdi-format-list-bulleted-square
                </v-icon>
              </v-btn>
            </div>
            <div class="box-container">
              <v-row>
                <v-col cols="12">
                  <v-data-iterator :items="items" :items-per-page.sync="itemsPerPage" :page.sync="page" hide-default-footer>
                    <template v-slot:default="props">
                      <v-row>
                        <v-col v-for="(item, index) in props.items" :key="index" cols="12" sm="6" md="6" lg="3" xl="3">
                          <!-- TODO product discount -->
                          <item-card :pId="item.id" :pImg="item.image" :pTitle="item.title" :originalPrice="item.price" :subTitle="item.sub_title" :pDiscount="Number(item.discount)" @cartAdd="addCart(item)">
                          </item-card>
                        </v-col>
                      </v-row>
                    </template>
                    <template v-slot:footer>
                      <v-row class="my-5 me-1" align="center" justify="center">
                        <v-spacer></v-spacer>
                        <span class="mr-4 grey--text">
                          Page {{ page }} of {{ numberOfPages }}
                        </span>
                        <v-btn fab :disabled="page == 1" small color="brown lighten-1" class="mr-1" @click="formerPage">
                          <v-icon>mdi-chevron-left</v-icon>
                        </v-btn>
                        <v-btn fab :disabled="page == numberOfPages" small color="brown lighten-1" class="ml-1" @click="nextPage">
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
import ItemCard from "@/components/productCard/ItemCard";
export default {
  components: {
    ItemCard
  },
  data () {
    return {
      isSidebar: false,
      page: 1,
      itemsPerPage: 12,
      range: [0, 100, 500, 1000],
      sortItems: ['Low to High', 'High to Low'],
      sortSelected: '',
      selected: [],
      items: [],
      value: '',
    };
  },
  watch: {
    $route () {
      this.searchProducts()
    },
  },
  computed: {
    numberOfPages () {
      return Math.ceil(this.items.length / this.itemsPerPage)
    },
  },
  created () {
    this.searchProducts();
  },
  methods: {
    searchProducts () {
      this.$axios.$post(`/api/products/search`, { value: this.$route.query.value }).then((res) => {
        var products = res;
        for (var m = 0; m < products.length; m++) {
          products[m].image = "http://localhost:3000" + products[m].images[0].medium.url;
          products[m].qty = 1;
        }
        this.items = products;
        this.value = this.$route.query.value;
      })
    },
    sort (price) {
      if (this.sortSelected == 'Low to High') {
        this.items = this.items.sort((a, b) => a[price] < b[price] ? -1 : 1)
      } else {
        this.items = this.items.sort((a, b) => a[price] > b[price] ? -1 : 1)
      }
    },
    nextPage () {
      if (this.page + 1 <= this.numberOfPages) this.page += 1
    },
    formerPage () {
      if (this.page - 1 >= 1) this.page -= 1
    },
    addCart (item) {
      // add to backend cart
      if (this.$auth.loggedIn) {
        this.$axios.$post(`api/products/${item.id}/add_to_cart`, {
          product_id: item.id,
          user_id: this.$auth.user.id
        }).then((res) => {
          // console.log(res);
        });
      }
      // add to store
      var cartItem = new Object();
      cartItem.product_id = item.id;
      cartItem.price = item.price;
      this.$store.commit('add_product_to_cart', cartItem);
    }
  }
};
</script>