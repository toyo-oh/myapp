<template>
  <div class="">
    <!-- sliders  -->
    <div class="white mb-60">
      <v-container>
        <v-row>
          <!-- TODO -->
          <!-- <v-col cols="12" xl="2" lg="3" class="pt-0 d-none d-lg-block">
            <Navbar />
          </v-col> -->
          <!-- <v-col cols="12" xl="10" lg="9"> -->
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
        </v-col>
        <v-row>
          <v-col cols="12" sm="2" md="2" lg="2" v-for="(item, index) in bestSellers" :key="index">
            <base-card>
              <v-card-text>
                <router-link :to="{name: 'products-id', params: {id: item.id}}">
                  <v-avatar tile :size="140">
                    <v-img class="card-overlay-item mb-2 br-8" :src="item.image"></v-img>
                  </v-avatar>
                </router-link>
                <router-link :to="{name: 'products-id', params: {id: item.id}}">
                  <h5 class="grey--text text--darken-4">{{ item.title }}</h5>
                </router-link>
                <div class="d-flex">
                  <h5 class="brown--text me-2">¥{{parseFloat(item.price*item.discount).toFixed(0)}}</h5>
                  <h5 class="grey--text text--darken-1 text-decoration-line-through">¥{{item.price}}</h5>
                </div>
              </v-card-text>
            </base-card>
          </v-col>
        </v-row>
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
        </v-col>
        <v-row>
          <v-col cols="12" sm="2" md="2" lg="2" v-for="(item, index) in newArrivals" :key="index">
            <base-card>
              <v-card-text>
                <router-link :to="{name: 'products-id', params: {id: item.id}}">
                  <v-avatar tile :size="140">
                    <v-img class="card-overlay-item mb-2 br-8" :src="item.image"></v-img>
                  </v-avatar>
                </router-link>
                <router-link :to="{name: 'products-id', params: {id: item.id}}">
                  <h5 class="grey--text text--darken-4">{{ item.title }}</h5>
                </router-link>
                <div class="d-flex">
                  <h5 class="brown--text me-2">¥{{parseFloat(item.price*item.discount).toFixed(0)}}</h5>
                  <h5 class="grey--text text--darken-1 text-decoration-line-through">¥{{item.price}}</h5>
                </div>
              </v-card-text>
            </base-card>
          </v-col>
        </v-row>
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
        </v-col>
        <v-col cols="12" sm="2" md="2" lg="2" v-for="(item, index) in bigDiscounts" :key="index">
          <base-card>
            <v-card-text>
              <router-link :to="{name: 'products-id', params: {id: item.id}}">
                <v-avatar tile :size="140">
                  <v-img class="card-overlay-item mb-2 br-8" :src="item.image"></v-img>
                </v-avatar>
              </router-link>
              <router-link :to="{name: 'products-id', params: {id: item.id}}">
                <h5 class="grey--text text--darken-4">{{ item.title }}</h5>
              </router-link>
              <div class="d-flex">
                <h5 class="brown--text me-2">¥{{parseFloat(item.price*item.discount).toFixed(0)}}</h5>
                <h5 class="grey--text text--darken-1 text-decoration-line-through">¥{{item.price}}</h5>
              </div>
            </v-card-text>
          </base-card>
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
        </v-col>
        <v-row>
          <v-col cols="12" sm="2" md="2" lg="2" v-for="(item, index) in topRatings" :key="index">
            <base-card>
              <v-card-text>
                <router-link :to="{name: 'products-id', params: {id: item.id}}">
                  <v-avatar tile :size="140">
                    <v-img class="card-overlay-item mb-2 br-8" :src="item.image"></v-img>
                  </v-avatar>
                </router-link>
                <router-link :to="{name: 'products-id', params: {id: item.id}}">
                  <h5 class="grey--text text--darken-4">{{ item.title }}</h5>
                </router-link>
                <div class="d-flex">
                  <h5 class="brown--text me-2">¥{{parseFloat(item.price*item.discount).toFixed(0)}}</h5>
                  <h5 class="grey--text text--darken-1 text-decoration-line-through">¥{{item.price}}</h5>
                </div>
              </v-card-text>
            </base-card>
          </v-col>
        </v-row>
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
          <v-row>
            <v-col cols="12" sm="6" md="6" lg="3" xl="3" v-for="(item, index) in category1" :key="index">
              <item-card :contentId="item.id" :content-img="item.image" :content-text="item.title" :originalPrice="item.price" :subTitle="item.sub_title" :discount="Number(item.discount)" @cartAdd="addCart(item)"></item-card>
            </v-col>
          </v-row>
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
            <v-col cols="12" sm="6" md="6" lg="3" xl="3" v-for="(item, index) in category2" :key="index">
              <item-card :contentId="item.id" :content-img="item.image" :content-text="item.title" :originalPrice="item.price" :subTitle="item.sub_title" :discount="Number(item.discount)" @cartAdd="addCart(item)"></item-card>
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
            <v-col cols="12" sm="6" md="6" lg="3" xl="3" v-for="(item, index) in category3" :key="index">
              <item-card :contentId="item.id" :content-img="item.image" :content-text="item.title" :originalPrice="item.price" :subTitle="item.sub_title" :discount="Number(item.discount)" @cartAdd="addCart(item)"></item-card>
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
            <v-col cols="12" sm="6" md="6" lg="3" xl="3" v-for="(item, index) in category4" :key="index">
              <item-card :contentId="item.id" :content-img="item.image" :content-text="item.title" :originalPrice="item.price" :subTitle="item.sub_title" :discount="Number(item.discount)" @cartAdd="addCart(item)"></item-card>
            </v-col>
          </v-row>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import ItemCard from "@/components/itemCard/ItemCard";
export default {
  components: {
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
    loadDatas () {
      this.$axios.get("api/products", {
      }).then((res) => {
        this.bestSellers = this.setImagePath(res.data.best_sellers, "thumb");
        this.topRatings = this.setImagePath(res.data.top_rankings, "thumb");
        this.newArrivals = this.setImagePath(res.data.new_arrivals, "thumb");
        this.bigDiscounts = this.setImagePath(res.data.big_discounts, "thumb");
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
    }
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


