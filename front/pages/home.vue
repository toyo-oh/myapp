<template>
  <div class="">
    <!-- sliders  -->
    <div class="white mb-60">
      <v-container>
        <v-row>
          <v-col cols="12">
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
                    <v-col cols="7" class="mb-14">
                      <v-col cols="12" class="ms-3">
                        <h1 class="text-h4 font-weight-black mb-4">
                          {{ item.title }}
                        </h1>
                      </v-col>
                      <v-col cols="8">
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
                    <v-col cols="4">
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
              <v-icon>mdi-menu-right</v-icon>
            </a>
          </div>
          <div>
            <v-row>
              <v-col v-for="(item, index) in bestSellers" :key="index" cols="3">
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
              <v-icon>mdi-menu-right</v-icon>
            </a>
          </div>
          <div>
            <v-row>
              <v-col v-for="(item, index) in newArrivals" :key="index" cols="3">
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
              <v-icon>mdi-menu-right</v-icon>
            </a>
          </div>
          <div>
            <v-row>
              <v-col v-for="(item, index) in bigDiscounts" :key="index" cols="3">
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
              <v-icon>mdi-menu-right</v-icon>
            </a>
          </div>
          <div>
            <v-row>
              <v-col v-for="(item, index) in topRatings" :key="index" cols="3">
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

    <!-- Coffee Beans  -->
    <v-container class="mb-60">
      <v-row>
        <v-col cols="12">
          <div class="d-flex justify-space-between mb-5">
            <h2 class="brown--text font-weight-bold">Coffee Beans</h2>
            <a
              class="text-decoration-none blue-grey--text darken-1"
              @click="viewAll('category_CoffeeBeans')">
              View all
              <v-icon>mdi-menu-right</v-icon>
            </a>
          </div>
          <div>
            <v-row>
              <v-col v-for="(item, index) in coffeeBeans" :key="index" cols="3">
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

    <!-- Drip Bag  -->
    <v-container class="mb-60">
      <v-row>
        <v-col cols="12">
          <div class="d-flex justify-space-between mb-5">
            <h2 class="brown--text font-weight-bold">Drip Bag</h2>
            <a
              class="text-decoration-none blue-grey--text darken-1"
              @click="viewAll('category_DripBag')">
              View all
              <v-icon>mdi-menu-right</v-icon>
            </a>
          </div>
          <v-row>
            <v-col v-for="(item, index) in dripBag" :key="index" cols="3">
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

    <!-- Liquid Coffee  -->
    <v-container class="mb-60">
      <v-row>
        <v-col cols="12">
          <div class="d-flex justify-space-between mb-5">
            <h2 class="brown--text font-weight-bold">Liquid Coffee</h2>
            <a
              class="text-decoration-none blue-grey--text darken-1"
              @click="viewAll('category_LiquidCoffee')">
              View all
              <v-icon>mdi-menu-right</v-icon>
            </a>
          </div>
          <v-row>
            <v-col v-for="(item, index) in liquidCoffee" :key="index" cols="3">
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

    <!-- Instant Coffee  -->
    <v-container class="mb-60">
      <v-row>
        <v-col cols="12">
          <div class="d-flex justify-space-between mb-5">
            <h2 class="brown--text font-weight-bold">Instant Coffee</h2>
            <a
              class="text-decoration-none blue-grey--text darken-1"
              @click="viewAll('category_InstantCoffee')">
              View all
              <v-icon>mdi-menu-right</v-icon>
            </a>
          </div>
          <v-row>
            <v-col v-for="(item, index) in instantCoffee" :key="index" cols="3">
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

    <!-- Sugar&Milk  -->
    <v-container class="mb-60">
      <v-row>
        <v-col cols="12">
          <div class="d-flex justify-space-between mb-5">
            <h2 class="brown--text font-weight-bold">Sugar&Milk</h2>
            <a
              class="text-decoration-none blue-grey--text darken-1"
              @click="viewAll('category_Sugar&Milk')">
              View all
              <v-icon>mdi-menu-right</v-icon>
            </a>
          </div>
          <v-row>
            <v-col v-for="(item, index) in sugarMilk" :key="index" cols="3">
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

    <!-- Coffee Tools  -->
    <v-container class="mb-60">
      <v-row>
        <v-col cols="12">
          <div class="d-flex justify-space-between mb-5">
            <h2 class="brown--text font-weight-bold">Coffee Tools</h2>
            <a
              class="text-decoration-none blue-grey--text darken-1"
              @click="viewAll('category_CoffeeTools')">
              View all
              <v-icon>mdi-menu-right</v-icon>
            </a>
          </div>
          <v-row>
            <v-col v-for="(item, index) in coffeeTools" :key="index" cols="3">
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
      coffeeBeans: [],
      dripBag: [],
      liquidCoffee: [],
      instantCoffee: [],
      sugarMilk: [],
      coffeeTools: [],
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
        this.coffeeBeans = res.data.coffeeBeans
        this.dripBag = res.data.dripBag
        this.liquidCoffee = res.data.liquidCoffee
        this.instantCoffee = res.data.instantCoffee
        this.sugarMilk = res.data.sugarMilk
        this.coffeeTools = res.data.coffeeTools
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
