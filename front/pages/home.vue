<template>
  <div class="">
    <!-- sliders  -->
    <div class="white mb-60">
      <v-container>
        <v-row>
          <v-col cols="12" xl="12" lg="12">
            <v-carousel cycle height="100%" light hide-delimiter-background show-arrows-on-hover :show-arrows="false">
              <v-carousel-item v-for="(item, index) in sliders" :key="index">
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
                          {{item.sub_title}}
                        </p>
                      </v-col>
                      <v-btn dark color="brown lighten-1" class="text-capitalize ms-3" @click="shopNow(item)">Shop Now</v-btn>
                    </v-col>
                    <v-col cols="5" lg="4">
                      <v-img aspect-ratio="1" contain :src="item.image"></v-img>
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
            <a @click="viewAll('best_sellers')" class="text-decoration-none blue-grey--text darken-1">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>
          <div>
            <v-row>
              <v-col cols="12" xs="6" sm="4" md="3" lg="2" xl="2" v-for="(item, index) in bestSellers" :key="index">
                <small-card :pId="item.id" :pImg="item.image" :pTitle="item.title" :originalPrice="item.price" :pDiscount="Number(item.discount)" @cartAdd="addToCart({'id':item.id, 'price':parseFloat(Number(item.price) * (1 - Number(item.discount))).toFixed(0)})"></small-card>
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
            <a @click="viewAll('new_arrivals')" class="text-decoration-none blue-grey--text darken-1">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>
          <div>
            <v-row>
              <v-col cols="12" xs="6" sm="4" md="3" lg="2" xl="2" v-for="(item, index) in newArrivals" :key="index">
                <small-card :pId="item.id" :pImg="item.image" :pTitle="item.title" :originalPrice="item.price" :pDiscount="Number(item.discount)" @cartAdd="addToCart({'id':item.id, 'price':parseFloat(Number(item.price) * (1 - Number(item.discount))).toFixed(0)})"></small-card>
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
            <a @click="viewAll('big_discounts')" class="text-decoration-none blue-grey--text darken-1">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>
          <div>
            <v-row>
              <v-col cols="12" xs="6" sm="4" md="3" lg="2" xl="2" v-for="(item, index) in bigDiscounts" :key="index">
                <small-card :pId="item.id" :pImg="item.image" :pTitle="item.title" :originalPrice="item.price" :pDiscount="Number(item.discount)" @cartAdd="addToCart({'id':item.id, 'price':parseFloat(Number(item.price) * (1 - Number(item.discount))).toFixed(0)})"></small-card>
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
            <a @click="viewAll('top_rankings')" class="text-decoration-none blue-grey--text darken-1">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>
          <div>
            <v-row>
              <v-col cols="12" xs="6" sm="4" md="3" lg="2" xl="2" v-for="(item, index) in topRatings" :key="index">
                <small-card :pId="item.id" :pImg="item.image" :pTitle="item.title" :originalPrice="item.price" :pDiscount="Number(item.discount)" @cartAdd="addToCart({'id':item.id, 'price':parseFloat(Number(item.price) * (1 - Number(item.discount))).toFixed(0)})"></small-card>
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
            <a @click="viewAll('category_1')" class="text-decoration-none blue-grey--text darken-1">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>
          <div>
            <v-row>
              <v-col cols="12" xs="6" sm="4" md="4" lg="3" xl="3" v-for="(item, index) in category1" :key="index">
                <item-card :pId="item.id" :pImg="item.image" :pTitle="item.title" :originalPrice="item.price" :subTitle="item.sub_title" :pDiscount="Number(item.discount)" @cartAdd="addToCart({'id':item.id, 'price':parseFloat(Number(item.price) * (1 - Number(item.discount))).toFixed(0)})"></item-card>
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
            <a @click="viewAll('category_2')" class="text-decoration-none blue-grey--text darken-1">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>
          <v-row>
            <v-col cols="12" xs="6" sm="4" md="4" lg="3" xl="3" v-for="(item, index) in category2" :key="index">
              <item-card :pId="item.id" :pImg="item.image" :pTitle="item.title" :originalPrice="item.price" :subTitle="item.sub_title" :pDiscount="Number(item.discount)" @cartAdd="addToCart({'id':item.id, 'price':parseFloat(Number(item.price) * (1 - Number(item.discount))).toFixed(0)})"></item-card>
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
            <a @click="viewAll('category_3')" class="text-decoration-none blue-grey--text darken-1">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>
          <v-row>
            <v-col cols="12" xs="6" sm="4" md="4" lg="3" xl="3" v-for="(item, index) in category3" :key="index">
              <item-card :pId="item.id" :pImg="item.image" :pTitle="item.title" :originalPrice="item.price" :subTitle="item.sub_title" :pDiscount="Number(item.discount)" @cartAdd="addToCart({'id':item.id, 'price':parseFloat(Number(item.price) * (1 - Number(item.discount))).toFixed(0)})"></item-card>
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
            <a @click="viewAll('category_4')" class="text-decoration-none blue-grey--text darken-1">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>
          <v-row>
            <v-col cols="12" xs="6" sm="4" md="4" lg="3" xl="3" v-for="(item, index) in category4" :key="index">
              <item-card :pId="item.id" :pImg="item.image" :pTitle="item.title" :originalPrice="item.price" :subTitle="item.sub_title" :pDiscount="Number(item.discount)" @cartAdd="addToCart({'id':item.id, 'price':parseFloat(Number(item.price) * (1 - Number(item.discount))).toFixed(0)})"></item-card>
            </v-col>
          </v-row>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import SmallCard from "@/components/productCard/SmallCard";
import ItemCard from "@/components/productCard/ItemCard";
import { mapActions } from 'vuex'
export default {
  components: {
    SmallCard,
    ItemCard
  },
  head: {
    title: 'Home'
  },
  created () {
    this.loadDatas();
  },
  data () {
    return {
      bestSellers: [],
      topRatings: [],
      newArrivals: [],
      bigDiscounts: [],
      category1: [],
      category2: [],
      category3: [],
      category4: [],
      // TODO (top products)
      sliders: [
        {
          'id': 2,
          'image': 'http://localhost:3000/uploads/product/images/2/medium_lamp2.jpeg',
          'title': '2_titletitletitletitletitletitletitletitle',
          'sub_title': '2_sub_titlesub_titlesub_titlesub_titlesub_titlesub_title'
        },
        {
          'id': 26,
          'image': 'http://localhost:3000/uploads/product/images/26/medium_cup1.jpg',
          'title': '26_titletitletitletitletitletitletitletitle',
          'sub_title': '26_sub_titlesub_titlesub_titlesub_titlesub_titlesub_title'
        },
        {
          'id': 23,
          'image': 'http://localhost:3000/uploads/product/images/23/medium_table2.jpeg',
          'title': '23_titletitletitletitletitletitletitletitle',
          'sub_title': '23_sub_titlesub_titlesub_titlesub_titlesub_titlesub_title'
        }]
    };
  },
  methods: {
    ...mapActions(['addToCart']),
    loadDatas () {
      this.$axios.get("api/products", {
      }).then((res) => {
        this.bestSellers = this.setImagePath(res.data.best_sellers, "medium");
        this.topRatings = this.setImagePath(res.data.top_rankings, "medium");
        this.newArrivals = this.setImagePath(res.data.new_arrivals, "medium");
        this.bigDiscounts = this.setImagePath(res.data.big_discounts, "medium");
        this.category1 = this.setImagePath(res.data.category_1, "medium");
        this.category2 = this.setImagePath(res.data.category_2, "medium");
        this.category3 = this.setImagePath(res.data.category_3, "medium");
        this.category4 = this.setImagePath(res.data.category_4, "medium");
      });
    },
    // TODO image path
    setImagePath (products, size) {
      if (products) {
        for (var m = 0; m < products.length; m++) {
          if (size == "medium") {
            products[m].image = "http://localhost:3000" + products[m].images[0].medium.url;
          }
          else {
            products[m].image = "http://localhost:3000" + products[m].images[0].thumb.url;
          }
        }
      }
      return products;
    },
    shopNow (item) {
      this.$router.push(`/products/${item.id}`)
    },
    viewAll (keyword) {
      this.$router.push({ path: '/search', query: { value: keyword } });
    },
  }
};
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


