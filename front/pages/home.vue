<template>
  <div class="">
    <!-- sliders  -->
    <div class="white mb-60">
      <v-container>
        <v-row>
          <v-col cols="12" xl="12" lg="12">
            <v-carousel
              cycle
              height="100%"
              light
              hide-delimiter-background
              show-arrows-on-hover
              :show-arrows="false">
              <v-carousel-item v-for="(item, index) in slideProducts" :key="index">
                <v-sheet height="100%" light>
                  <v-row class="fill-height" align="center">
                    <v-col cols="7" lg="8" class="mb-14 mb-sm-0">
                      <v-col cols="12" xl="7" class="ms-3 ps-0">
                        <h1 class="text-h3 font-weight-black mb-4">
                          {{ item.title }}
                        </h1>
                      </v-col>
                      <v-col cols="12" xl="8">
                        <p class="text--secondary mb-4">
                          {{ item.sub_title }}
                        </p>
                      </v-col>
                      <v-btn
                        dark
                        color="brown lighten-1"
                        class="text-capitalize ms-3"
                        @click="shopNow(item)"
                        >Shop Now</v-btn
                      >
                    </v-col>
                    <v-col cols="5" lg="4">
                      <v-img aspect-ratio="1" contain :src="item.images[0].medium.url"></v-img>
                    </v-col>
                  </v-row>
                </v-sheet>
              </v-carousel-item>
            </v-carousel>
          </v-col>
        </v-row>
      </v-container>
    </div>

    <!-- Best Sellers  -->
    <v-container class="mb-60">
      <v-row>
        <v-col cols="12">
          <div class="d-flex justify-space-between align-center mb-4">
            <div class="d-flex align-center">
              <h2 class="brown--text font-weight-bold">Best Sellers</h2>
            </div>
            <a
              class="text-decoration-none blue-grey--text darken-1"
              @click="viewAll('best_sellers')">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>
          <div>
            <v-row>
              <v-col
                v-for="(item, index) in bestSellers"
                :key="index"
                cols="12"
                xs="6"
                sm="4"
                md="4"
                lg="3"
                xl="3">
                <item-card
                  :p-id="item.id"
                  :p-hash-id="item.hashid"
                  :p-img="item.images[0].medium.url"
                  :p-title="item.title"
                  :original-price="item.price"
                  :sub-title="item.sub_title"
                  :p-discount="Number(item.discount)"
                  @cartAdd="
                    addToCart({
                      hashid: item.hashid,
                      price: parseFloat(Number(item.price) * (1 - Number(item.discount))).toFixed(
                        0
                      ),
                    })
                  "></item-card>
              </v-col>
            </v-row>
          </div>
        </v-col>
      </v-row>
    </v-container>

    <!-- New Arrivals  -->
    <v-container class="mb-60">
      <v-row>
        <v-col cols="12">
          <div class="d-flex justify-space-between align-center mb-4">
            <div class="d-flex align-center">
              <h2 class="brown--text font-weight-bold">New Arrivals</h2>
            </div>
            <a
              class="text-decoration-none blue-grey--text darken-1"
              @click="viewAll('new_arrivals')">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>
          <div>
            <v-row>
              <v-col
                v-for="(item, index) in newArrivals"
                :key="index"
                cols="12"
                xs="6"
                sm="4"
                md="4"
                lg="3"
                xl="3">
                <item-card
                  :p-id="item.id"
                  :p-hash-id="item.hashid"
                  :p-img="item.images[0].medium.url"
                  :p-title="item.title"
                  :original-price="item.price"
                  :sub-title="item.sub_title"
                  :p-discount="Number(item.discount)"
                  @cartAdd="
                    addToCart({
                      hashid: item.hashid,
                      price: parseFloat(Number(item.price) * (1 - Number(item.discount))).toFixed(
                        0
                      ),
                    })
                  "></item-card>
              </v-col>
            </v-row>
          </div>
        </v-col>
      </v-row>
    </v-container>

    <!-- Big Discounts  -->
    <v-container class="mb-60">
      <v-row>
        <v-col cols="12">
          <div class="d-flex justify-space-between align-center mb-4">
            <div class="d-flex align-center">
              <h2 class="brown--text font-weight-bold">Big Discounts</h2>
            </div>
            <a
              class="text-decoration-none blue-grey--text darken-1"
              @click="viewAll('big_discounts')">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>
          <div>
            <v-row>
              <v-col
                v-for="(item, index) in bigDiscounts"
                :key="index"
                cols="12"
                xs="6"
                sm="4"
                md="4"
                lg="3"
                xl="3">
                <item-card
                  :p-id="item.id"
                  :p-hash-id="item.hashid"
                  :p-img="item.images[0].medium.url"
                  :p-title="item.title"
                  :original-price="item.price"
                  :sub-title="item.sub_title"
                  :p-discount="Number(item.discount)"
                  @cartAdd="
                    addToCart({
                      hashid: item.hashid,
                      price: parseFloat(Number(item.price) * (1 - Number(item.discount))).toFixed(
                        0
                      ),
                    })
                  "></item-card>
              </v-col>
            </v-row>
          </div>
        </v-col>
      </v-row>
    </v-container>

    <!-- Top Rankings  -->
    <v-container class="mb-60">
      <v-row>
        <v-col cols="12">
          <div class="d-flex justify-space-between align-center mb-4">
            <div class="d-flex align-center">
              <h2 class="brown--text font-weight-bold">Top Rankings</h2>
            </div>
            <a
              class="text-decoration-none blue-grey--text darken-1"
              @click="viewAll('top_rankings')">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>
          <div>
            <v-row>
              <v-col
                v-for="(item, index) in topRatings"
                :key="index"
                cols="12"
                xs="6"
                sm="4"
                md="4"
                lg="3"
                xl="3">
                <item-card
                  :p-id="item.id"
                  :p-hash-id="item.hashid"
                  :p-img="item.images[0].medium.url"
                  :p-title="item.title"
                  :original-price="item.price"
                  :sub-title="item.sub_title"
                  :p-discount="Number(item.discount)"
                  @cartAdd="
                    addToCart({
                      hashid: item.hashid,
                      price: parseFloat(Number(item.price) * (1 - Number(item.discount))).toFixed(
                        0
                      ),
                    })
                  "></item-card>
              </v-col>
            </v-row>
          </div>
        </v-col>
      </v-row>
    </v-container>

    <!-- Category 1  -->
    <v-container class="mb-60">
      <v-row>
        <v-col cols="12">
          <div class="d-flex justify-space-between mb-5">
            <h2 class="brown--text font-weight-bold">Category 1</h2>
            <a class="text-decoration-none blue-grey--text darken-1" @click="viewAll('category_1')">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>
          <div>
            <v-row>
              <v-col
                v-for="(item, index) in category1"
                :key="index"
                cols="12"
                xs="6"
                sm="4"
                md="4"
                lg="3"
                xl="3">
                <item-card
                  :p-id="item.id"
                  :p-hash-id="item.hashid"
                  :p-img="item.images[0].medium.url"
                  :p-title="item.title"
                  :original-price="item.price"
                  :sub-title="item.sub_title"
                  :p-discount="Number(item.discount)"
                  @cartAdd="
                    addToCart({
                      hashid: item.hashid,
                      price: parseFloat(Number(item.price) * (1 - Number(item.discount))).toFixed(
                        0
                      ),
                    })
                  "></item-card>
              </v-col>
            </v-row>
          </div>
        </v-col>
      </v-row>
    </v-container>

    <!-- Category 2  -->
    <v-container class="mb-60">
      <v-row>
        <v-col cols="12">
          <div class="d-flex justify-space-between mb-5">
            <h2 class="brown--text font-weight-bold">Category 2</h2>
            <a class="text-decoration-none blue-grey--text darken-1" @click="viewAll('category_2')">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>
          <v-row>
            <v-col
              v-for="(item, index) in category2"
              :key="index"
              cols="12"
              xs="6"
              sm="4"
              md="4"
              lg="3"
              xl="3">
              <item-card
                :p-id="item.id"
                :p-hash-id="item.hashid"
                :p-img="item.images[0].medium.url"
                :p-title="item.title"
                :original-price="item.price"
                :sub-title="item.sub_title"
                :p-discount="Number(item.discount)"
                @cartAdd="
                  addToCart({
                    hashid: item.hashid,
                    price: parseFloat(Number(item.price) * (1 - Number(item.discount))).toFixed(0),
                  })
                "></item-card>
            </v-col>
          </v-row>
        </v-col>
      </v-row>
    </v-container>

    <!-- Category 3  -->
    <v-container class="mb-60">
      <v-row>
        <v-col cols="12">
          <div class="d-flex justify-space-between mb-5">
            <h2 class="brown--text font-weight-bold">Category 3</h2>
            <a class="text-decoration-none blue-grey--text darken-1" @click="viewAll('category_3')">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>
          <v-row>
            <v-col
              v-for="(item, index) in category3"
              :key="index"
              cols="12"
              xs="6"
              sm="4"
              md="4"
              lg="3"
              xl="3">
              <item-card
                :p-id="item.id"
                :p-hash-id="item.hashid"
                :p-img="item.images[0].medium.url"
                :p-title="item.title"
                :original-price="item.price"
                :sub-title="item.sub_title"
                :p-discount="Number(item.discount)"
                @cartAdd="
                  addToCart({
                    hashid: item.hashid,
                    price: parseFloat(Number(item.price) * (1 - Number(item.discount))).toFixed(0),
                  })
                "></item-card>
            </v-col>
          </v-row>
        </v-col>
      </v-row>
    </v-container>

    <!-- Category 4  -->
    <v-container class="mb-60">
      <v-row>
        <v-col cols="12">
          <div class="d-flex justify-space-between mb-5">
            <h2 class="brown--text font-weight-bold">Category 4</h2>
            <a class="text-decoration-none blue-grey--text darken-1" @click="viewAll('category_4')">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>
          <v-row>
            <v-col
              v-for="(item, index) in category4"
              :key="index"
              cols="12"
              xs="6"
              sm="4"
              md="4"
              lg="3"
              xl="3">
              <item-card
                :p-id="item.id"
                :p-hash-id="item.hashid"
                :p-img="item.images[0].medium.url"
                :p-title="item.title"
                :original-price="item.price"
                :sub-title="item.sub_title"
                :p-discount="Number(item.discount)"
                @cartAdd="
                  addToCart({
                    hashid: item.hashid,
                    price: parseFloat(Number(item.price) * (1 - Number(item.discount))).toFixed(0),
                  })
                "></item-card>
            </v-col>
          </v-row>
        </v-col>
      </v-row>
    </v-container>
  </div>
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
      bestSellers: [],
      topRatings: [],
      newArrivals: [],
      bigDiscounts: [],
      category1: [],
      category2: [],
      category3: [],
      category4: [],
      slideProducts: [],
    }
  },
  head: {
    title: "Home",
  },
  created() {
    this.loadDatas()
  },
  methods: {
    ...mapActions(["addToCart"]),
    loadDatas() {
      this.$axios.get("api/products", {}).then((res) => {
        this.bestSellers = res.data.best_sellers
        this.topRatings = res.data.top_rankings
        this.newArrivals = res.data.new_arrivals
        this.bigDiscounts = res.data.big_discounts
        this.category1 = res.data.category1
        this.category2 = res.data.category2
        this.category3 = res.data.category3
        this.category4 = res.data.category4
        this.slideProducts = res.data.slide_products
      })
    },
    shopNow(item) {
      this.$router.push(`/products/${item.hashid}`)
    },
    viewAll(keyword) {
      this.$router.push({ path: "/search", query: { value: keyword } })
    },
  },
}
</script>
<style lang="scss" scoped>
.router-link-active {
  text-decoration: none;
  color: brown;
}
a {
  text-decoration: none;
  color: white;
}
</style>
