<template>
  <div class="">
    <!-- section-1  -->
    <div class="white mb-60">
      <v-container>
        <v-row>
          <v-col cols="12" xl="2" lg="3" class="pt-0 d-none d-lg-block">
            <Navbar />
          </v-col>
          <v-col cols="12" xl="10" lg="9">
            <v-carousel cycle height="100%" hide-delimiter-background show-arrows-on-hover :show-arrows="false">
              <v-carousel-item v-for="(n, index) in heroSlider" :key="index">
                <v-sheet height="100%" light>
                  <v-row class="fill-height" align="center">
                    <v-col cols="7" lg="8" class="mb-14 mb-sm-0">
                      <v-col cols="12" xl="7" class="ms-3 ps-0">
                        <h1 class="show-3 font-weight-bold mb-4">
                          {{ n.name }}
                        </h1>
                      </v-col>
                      <v-col cols="12" xl="8">
                        <p class="secondary--text banner-text mb-4">
                          Lorem ipsum dolor sit amet, consectetur adipiscing
                          elit. Quis lobortis consequat eu, quam etiam at quis
                          ut convallis.
                        </p>
                      </v-col>
                      <v-btn color="primary" class="text-capitalize ms-3">Shop Now</v-btn>
                    </v-col>
                    <v-col cols="5" lg="4">
                      <v-img aspect-ratio="1" contain :src="n.img"></v-img>
                    </v-col>
                  </v-row>
                </v-sheet>
              </v-carousel-item>
            </v-carousel>
          </v-col>
        </v-row>
      </v-container>
    </div>

    <!-- section-2  -->
    <!-- <div class="container mb-60">
      <v-row>
        <v-col cols="12">
          <div class="d-flex justify-space-between mb-4">
            <div class="d-flex align-center">
              <v-avatar size="24" tile>
                <img class="icon mr-2 primary--text" src="@/assets/images/icons/light.svg" alt="" />
              </v-avatar>
              <h2 class="font-weight-bold">Flash Deals</h2>
            </div>
            <a href="#" class="text-decoration-none blue-grey--text darken-1">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>
        </v-col>
        <v-col cols="12" class="px-0">
          <div class="">
            <VueSlickCarousel class="slick-secondary" :arrows="true" :dots="false" v-bind="slickSettings">
              <v-col cols="12" v-for="(item, index) in getProducts.slice(16, 24).map(n => n)" :key="index">
                <CardCart :content-img="item.img" :content-text="item.title" :counter="item.qty" class="m-5" @cartRemove="removeCart(item)" @cartAdd="addCart(item)" />
              </v-col>

              <template #prevArrow="arrowOption">
                <v-btn class="mx-2 slick-arrow prev slick-prev" fab dark small color="secondary">
                  <v-icon dark>
                    {{ arrowOption }}
                    mdi-arrow-left
                  </v-icon>
                </v-btn>
              </template>
              <template #nextArrow="arrowOption">
                <v-btn class="mx-2 slick-arrow next slick-next" fab dark small color="secondary">
                  <v-icon dark>
                    {{ arrowOption }}
                    mdi-arrow-right
                  </v-icon>
                </v-btn>
              </template>
            </VueSlickCarousel>
          </div>
        </v-col>
      </v-row>
    </div> -->

    <!-- section-3  -->
    <!-- <div class="container mb-60">
      <v-row>
        <v-col cols="12">
          <div class="d-flex justify-space-between align-center mb-4">
            <div class="d-flex align-center">
              <v-avatar size="24" tile>
                <img class="icon mr-2 primary--text" src="@/assets/images/icons/categories.svg" alt="" />
              </v-avatar>

              <h2 class="font-weight-bold">Top Categories</h2>
            </div>
            <a href="#" class="text-decoration-none blue-grey--text darken-1">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>
        </v-col>
      </v-row>
      <div>
        <VueSlickCarousel class="slick-secondary" :arrows="true" :dots="false" v-bind="slickSettingsTwo">
          <div class="m-5" v-for="(n, index) in topCategories" :key="index">
            <v-col cols="12" class="">
              <nuxt-link to="/shop/SingleProduct">
                <base-card class="">
                  <v-card-text class="d-flex justify-content-center p-4 mx-auto">
                    <div class="card-overlay-item br-8 overflow-hidden">
                      <v-chip class="mt-2 ma-2 p-absolute" color="secondary" small>
                        Headphone
                      </v-chip>
                      <v-chip class="mt-2 ma-2 p-absolute right-0" color="grey lighten-3" small>
                        Headphone
                      </v-chip>
                      <a href="">
                        <img class="top-categories-img br-8 mx-auto" :src="n.img" alt="" />
                      </a>
                    </div>
                  </v-card-text>
                </base-card>
              </nuxt-link>

            </v-col>
          </div>
          <template #prevArrow="arrowOption">
            <v-btn class="mx-2 slick-arrow prev slick-prev" fab dark small color="secondary">
              <v-icon dark>
                {{ arrowOption }}
                mdi-arrow-left
              </v-icon>
            </v-btn>
          </template>
          <template #nextArrow="arrowOption">
            <v-btn class="mx-2 slick-arrow next slick-next" fab dark small color="secondary">
              <v-icon dark>
                {{ arrowOption }}
                mdi-arrow-right
              </v-icon>
            </v-btn>
          </template>
        </VueSlickCarousel>
      </div>
    </div> -->

    <!-- section-4  -->
    <!-- <v-container class="mb-60">
      <v-row>
        <v-col cols="12" lg="6" xl="6">
          <div class="d-flex justify-space-between align-center mb-4">
            <div class="d-flex align-center">
              <img v-svg-inline class="icon mr-2" src="@/assets/images/icons/ranking-1.svg" alt="" />
              <h2 class="font-weight-bold">Top Ratings</h2>
            </div>
            <a href="#" class="text-decoration-none blue-grey--text darken-1">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>
          <div>
            <base-card>
              <v-card-text>
                <v-row>
                  <v-col cols="6" md="4" lg="3" xl="3" v-for="(n, index) in topRatings" :key="index">
                    <nuxt-link to="/shop/SingleProduct">
                      <v-img class="mb-4 card-overlay-item" contain :src="n.img"></v-img>
                    </nuxt-link>
                    <div class="d-flex align-center justify-center mb-1">
                      <v-rating :value="4.5" color="amber" dense half-increments readonly size="16"></v-rating>

                      <div class="grey--text text--darken-4 ml-1">(49)</div>
                    </div>

                    <nuxt-link to="/shop/SingleProduct" class="text-decoration-none">
                      <h5 class="text-center mb-1 grey--text text--darken-3">{{ n.title }}</h5>
                      <h5 class="primary--text text-center">{{ n.price }}</h5>
                    </nuxt-link>

                  </v-col>
                </v-row>
              </v-card-text>
            </base-card>
          </div>
        </v-col>
        <v-col cols="12" lg="6" xl="6">
          <div class="d-flex justify-space-between align-center mb-4">
            <div class="d-flex align-center">

              <img v-svg-inline class="icon mr-2" src="@/assets/images/icons/Group.svg" alt="" />

              <h2 class="font-weight-bold">Featured Brands</h2>
            </div>
            <a href="#" class="text-decoration-none blue-grey--text darken-1">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>
          <div>
            <base-card>
              <v-card-text>
                <v-row>
                  <v-col cols="12" sm="6" v-for="(n, index) in featuredBrands" :key="index">
                    <nuxt-link to="/shop/SingleProduct">
                      <v-img class="mb-4 card-overlay-item br-8" cover aspect-ratio="1.7" :src="n.img"></v-img>
                    </nuxt-link>
                    <nuxt-link to="/shop/SingleProduct" class="text-decoration-none">
                      <h5 class="grey--text text--darken-4">{{ n.title }}</h5>
                    </nuxt-link>
                  </v-col>
                </v-row>
              </v-card-text>
            </base-card>
          </div>
        </v-col>
      </v-row>
    </v-container> -->

    <!-- section-5  -->
    <v-container class="mb-60">
      <v-row>
        <v-col cols="12">
          <div class="d-flex justify-space-between align-center mb-4">
            <div class="d-flex align-center">
              <img v-svg-inline class="icon mr-2" src="" alt="" />

              <h2 class="font-weight-bold">New Arrivals</h2>
            </div>
            <a href="#" class="text-decoration-none blue-grey--text darken-1">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>
          <div>
            <base-card>
              <v-card-text>
                <v-row>
                  <v-col cols="6" md="4" lg="2" xl="2" v-for="(n, index) in newArrivals" :key="index">
                    <nuxt-link to="/shop/SingleProduct" class="text-decoration-none">
                      <v-img class="mb-4 br-8 card-overlay-item" contain :src="n.img"></v-img>

                      <h5 class="mb-1 grey--text text--darken-3">{{ n.title }}</h5>
                      <h5 class="primary--text">{{ n.price }}</h5>
                    </nuxt-link>
                  </v-col>
                </v-row>
              </v-card-text>
            </base-card>
          </div>
        </v-col>
      </v-row>
    </v-container>

    <!-- section-6  -->
    <v-container class="mb-60">
      <v-row>
        <v-col cols="12">
          <div class="d-flex justify-space-between align-center mb-4">
            <div class="d-flex align-center">
              <img v-svg-inline class="icon mr-2" src="" alt="" />

              <h2 class="font-weight-bold">Big Discounts</h2>
            </div>
            <a href="#" class="text-decoration-none blue-grey--text darken-1">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>
        </v-col>
        <v-col cols="12" class="px-0">
          <div>
            <!-- <VueSlickCarousel class="slick-secondary" :arrows="true" :dots="false" v-bind="slickSettingsThree"> -->
            <div class="m-5" v-for="(n, index) in bigDiscounts" :key="index">
              <v-col cols="12">
                <base-card>
                  <v-card-text>
                    <nuxt-link to="/shop/SingleProduct" class="text-decoration-none">
                      <v-img class="card-overlay-item mb-2 br-8" :src="n.img"></v-img>
                    </nuxt-link>
                    <nuxt-link to="/shop/SingleProduct" class="text-decoration-none">
                      <h5 class="grey--text text--darken-4">{{ n.title }}</h5>
                    </nuxt-link>
                    <div class="d-flex">
                      <h5 class="primary--text me-2">$250</h5>
                      <h5 class="grey--text text--darken-1 text-decoration-line-through">$250</h5>
                    </div>
                  </v-card-text>
                </base-card>
              </v-col>
            </div>
            <!-- <template #prevArrow="arrowOption">
              <v-btn class="mx-2 slick-arrow prev slick-prev" fab dark small color="secondary">
                <v-icon dark>
                  {{ arrowOption }}
                  mdi-arrow-left
                </v-icon>
              </v-btn>
            </template>
            <template #nextArrow="arrowOption">
              <v-btn class="mx-2 slick-arrow next slick-next" fab dark small color="secondary">
                <v-icon dark>
                  {{ arrowOption }}
                  mdi-arrow-right
                </v-icon>
              </v-btn>
            </template> -->
            <!-- </VueSlickCarousel> -->
          </div>
        </v-col>
      </v-row>
    </v-container>

    <!-- section-7  -->
    <v-container class="mb-60">
      <v-row>
        <v-col cols="12" lg="3" xl="2">
          <base-card>
            <v-card-text>
              <div class="" v-for="(brand, index) in brandsIcon" :key="index">
                <v-btn block class="mb-3 text-capitalize py-5" elevation="0" color="grey lighten-2 ">
                  <v-avatar size="16" tile class="me-4">
                    <img :src="brand.image" alt="" />
                  </v-avatar>
                  <span>{{ brand.name }}</span>
                </v-btn>
              </div>
              <div class="mb-60"></div>
              <v-btn class="text-capitalize py-5" block elevation="0" color="grey lighten-2 ">
                <span>View All Brands</span>
              </v-btn>
            </v-card-text>
          </base-card>
        </v-col>
        <v-col cols="12" lg="9" xl="10">
          <div class="d-flex justify-space-between mb-5">
            <h2 class="font-weight-bold">Cars</h2>
            <a href="#" class="text-decoration-none blue-grey--text darken-1">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>

          <v-row>
            <v-col cols="12" sm="6" md="6" lg="4" xl="3" v-for="(item, index) in getProducts.slice(25, 32).map(n => n)" :key="index">
              <!-- <CardCart cardHoverShadow :content-img="item.img" :content-text="item.title" :counter="item.qty" class="m-5" @cartRemove="removeCart(item)" @cartAdd="addCart(item)" /> -->
            </v-col>
          </v-row>
        </v-col>
      </v-row>
    </v-container>

    <!-- section-8  -->
    <v-container class="mb-60">
      <v-row>
        <v-col cols="12" lg="3" xl="2">
          <base-card>
            <v-card-text>
              <v-tabs v-model="tab" background-color="transparent" color="black" class="brand-tabs mb-3">
                <v-tab class="text-capitalize">
                  <h3 class="font-weight-bold">Brands</h3>
                </v-tab>
                <div class="d-flex align-center grey--text text--lighten-1">
                  |
                </div>
                <v-tab class="text-capitalize">
                  <h3 class="font-weight-bold">Shops</h3>
                </v-tab>
              </v-tabs>

              <v-tabs-items v-model="tab">
                <v-tab-item v-for="item in 2" :key="item">
                  <div class="" v-for="(brand, index) in brandsIcon" :key="index">
                    <v-btn block class="mb-3 text-capitalize py-5" elevation="0" color="grey lighten-2 ">
                      <v-avatar size="16" tile class="me-4">
                        <img :src="brand.image" alt="" />
                      </v-avatar>
                      <span>{{ brand.name }}</span>
                    </v-btn>
                  </div>
                  <div class="mb-60"></div>
                  <v-btn class="text-capitalize py-5" block elevation="0" color="grey lighten-2 ">
                    <span>View All Brands</span>
                  </v-btn>
                </v-tab-item>
              </v-tabs-items>
            </v-card-text>
          </base-card>
        </v-col>
        <v-col cols="12" lg="9" xl="10">
          <div class="d-flex justify-space-between mb-5">
            <h2 class="font-weight-bold">Mobile Phones</h2>
            <a href="#" class="text-decoration-none blue-grey--text darken-1">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>

          <v-row>
            <v-col cols="12" sm="6" md="6" lg="4" xl="3" v-for="(item, index) in  getProducts.slice(32, 40).map(n => n)" :key="index">
              <!-- <CardCart cardHoverShadow :content-img="item.img" :content-text="item.title" :counter="item.qty" @cartRemove="removeCart(item)" @cartAdd="addCart(item)" :amount="item.amount" /> -->
            </v-col>
          </v-row>
        </v-col>
      </v-row>
    </v-container>

    <!-- section-9  -->
    <v-container class="mb-60">
      <div class="row">
        <v-col cols="12" sm="6" md="4" lg="4">
          <a href="#">
            <v-img cover src=""></v-img>
          </a>
        </v-col>

        <v-col cols="12" sm="6" md="8" lg="8">
          <a href="#">
            <v-img cover src=""></v-img>
          </a>
        </v-col>
      </div>
    </v-container>

    <!-- section-10  -->
    <v-container class="mb-60">
      <v-row>
        <v-col cols="12" lg="3" xl="2">
          <base-card>
            <v-card-text>
              <v-tabs v-model="tab" background-color="transparent" color="black" class="brand-tabs mb-3">
                <v-tab class="text-capitalize">
                  <h3 class="font-weight-bold">Brands</h3>
                </v-tab>
                <div class="d-flex align-center grey--text text--lighten-1">
                  |
                </div>
                <v-tab class="text-capitalize">
                  <h3 class="font-weight-bold">Shops</h3>
                </v-tab>
              </v-tabs>

              <v-tabs-items v-model="tab">
                <v-tab-item v-for="item in 2" :key="item">
                  <div class="" v-for="(brand, index) in brandsIcon" :key="index">
                    <v-btn block class="mb-3 text-capitalize py-5" elevation="0" color="grey lighten-2 ">
                      <v-avatar size="16" tile class="me-4">
                        <img :src="brand.image" alt="" />
                      </v-avatar>
                      <span>{{ brand.name }}</span>
                    </v-btn>
                  </div>
                  <div class="mb-60"></div>
                  <v-btn class="text-capitalize" block elevation="0" color="grey lighten-2 ">
                    <span>View All Brands</span>
                  </v-btn>
                </v-tab-item>
              </v-tabs-items>
            </v-card-text>
          </base-card>
        </v-col>
        <v-col cols="12" lg="9" xl="10">
          <div class="d-flex justify-space-between mb-5">
            <h2 class="font-weight-bold">Optics / Watch</h2>
            <a href="#" class="text-decoration-none blue-grey--text darken-1">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>

          <v-row>
            <v-col cols="12" sm="6" md="6" lg="4" xl="3" v-for="(item, index) in getProducts.slice(41, 48).map(n => n)" :key="index">
              <!-- <CardCart cardHoverShadow :content-img="item.img" :content-text="item.title" :counter="item.qty" @cartRemove="removeCart(item)" @cartAdd="addCart(item)" :amount="item.amount" /> -->
            </v-col>
          </v-row>
        </v-col>
      </v-row>
    </v-container>

    <!-- section-11  -->
    <v-container class="mb-60">
      <v-row>
        <v-col cols="12">
          <div class="d-flex justify-space-between mb-4">
            <div class="d-flex align-center">
              <v-avatar size="24" tile>
                <img class="icon primary--text mr-2" src="" alt="" />
              </v-avatar>

              <h2 class="font-weight-bold">Categories</h2>
            </div>
            <a href="#" class="text-decoration-none blue-grey--text darken-1">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>
        </v-col>
        <v-col v-for="(n, index) in categories" :key="index" cols="6" sm="4" md="3" lg="2">
          <base-card class="card-hover-shadow">
            <v-card-text>
              <div class="d-flex align-center">
                <v-avatar tile>
                  <img class="mr-3" :src="n.img" alt="" />
                </v-avatar>
                <p class="font-weight-bold mb-0 text-truncate">
                  {{ n.title }}
                </p>
              </div>
            </v-card-text>
          </base-card>
        </v-col>
      </v-row>
    </v-container>

    <!-- section-12  -->
    <v-container class="mb-60">
      <v-row>
        <v-col cols="12">
          <div class="d-flex justify-space-between mb-5">
            <h2 class="font-weight-bold">More For You</h2>
            <a href="#" class="text-decoration-none blue-grey--text darken-1">
              View all
              <v-icon class="m-0 p-0">mdi-menu-right</v-icon>
            </a>
          </div>

          <v-row>
            <v-col cols="12" sm="6" md="4" lg="3" xl="2" v-for="(item, index) in getProducts.slice(48, 60).map(n => n)" :key="index">
              <!-- <CardCart cardHoverShadow :content-img="item.img" :content-text="item.title" :counter="item.qty" @cartRemove="removeCart(item)" @cartAdd="addCart(item)" :amount="item.amount" /> -->
            </v-col>
          </v-row>
        </v-col>
      </v-row>
    </v-container>

    <!-- section-13  -->
    <v-container class="mb-60">
      <v-row>
        <v-col cols="12" sm="6" md="4" lg="3" xl="3">
          <base-card cardHoverShadow class="py-48">
            <v-card-text class="d-flex align-center justify-center flex-column">
              <div class="
                  py-5
                  avatar-64
                  d-flex
                  flex-row
                  justify-center
                  align-center
                  grey
                  lighten-2
                  rounded-circle
                  mb-5
                ">
                <v-avatar size="24">
                  <img class="icon secondary--text text--darken-1 mr-0" src="" alt="" />
                </v-avatar>
              </div>
              <h4 class="grey--text text--darken-4 mb-3">
                Worldwide Delivery
              </h4>
              <v-card-subtitle class="text-center grey--text text--darken-2 pt-0">We offer competitive prices on our 100 million plus product any
                range.</v-card-subtitle>
            </v-card-text>
          </base-card>
        </v-col>
        <v-col cols="12" sm="6" md="4" lg="3" xl="3">
          <base-card cardHoverShadow class="py-48">
            <v-card-text class="d-flex align-center justify-center flex-column">
              <div class="
                  py-5
                  avatar-64
                  d-flex
                  flex-row
                  justify-center
                  align-center
                  grey
                  lighten-2
                  rounded-circle
                  mb-5
                ">
                <img v-svg-inline class="icon secondary--text text--darken-1 mr-0" src="" alt="" />
              </div>
              <h4 class="grey--text text--darken-4 mb-3">
                Safe Payment
              </h4>
              <v-card-subtitle class="text-center grey--text text--darken-2 pt-0">We offer competitive prices on our 100 million plus product any
                range.</v-card-subtitle>
            </v-card-text>
          </base-card>
        </v-col>
        <v-col cols="12" sm="6" md="4" lg="3" xl="3">
          <base-card cardHoverShadow class="py-48">
            <v-card-text class="d-flex align-center justify-center flex-column">
              <div class="
                  py-5
                  avatar-64
                  d-flex
                  flex-row
                  justify-center
                  align-center
                  grey
                  lighten-2
                  rounded-circle
                  mb-5
                ">
                <img class="icon secondary--text text--darken-1 mr-0" src="" alt="" />
              </div>
              <h4 class="grey--text text--darken-4 mb-3">
                Shop With Confidence
              </h4>
              <v-card-subtitle class="text-center grey--text text--darken-2 pt-0">We offer competitive prices on our 100 million plus product any
                range.</v-card-subtitle>
            </v-card-text>
          </base-card>
        </v-col>
        <v-col cols="12" sm="6" md="4" lg="3" xl="3">
          <base-card cardHoverShadow class="py-48">
            <v-card-text class="d-flex align-center justify-center flex-column">
              <div class="
                  py-5
                  avatar-64
                  d-flex
                  flex-row
                  justify-center
                  align-center
                  grey
                  lighten-2
                  rounded-circle
                  mb-5
                ">
                <img v-svg-inline class="icon secondary--text text--darken-1 mr-0" src="" alt="" />
              </div>
              <h4 class="grey--text text--darken-4 mb-3">
                24/7 Support
              </h4>
              <v-card-subtitle class="text-center grey--text text--darken-2 pt-0">We offer competitive prices on our 100 million plus product any
                range.</v-card-subtitle>
            </v-card-text>
          </base-card>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
// import Navbar from "@/pages/home/navbar";
// import CardCart from "@/components/cartCard/CardCart";
import { mapGetters, mapActions } from 'vuex';
export default {
  // name: 'Home',
  components: {
    Navbar,
    CardCart,
  },
  computed: {
    ...mapGetters(['getProducts']),
  },
  head: {
    title: 'Home'
  },
  data () {
    return {
      flash: "",
      slickSettings: {
        infinite: false,
        speed: 500,
        slidesToShow: 6,
        slidesToScroll: 6,
        initialSlide: 0,
        responsive: [
          {
            breakpoint: 2100,
            settings: {
              slidesToShow: 6,
              slidesToScroll: 6,
              infinite: true,
            },
          },
          {
            breakpoint: 1900,
            settings: {
              slidesToShow: 4,
              slidesToScroll: 4,
              infinite: true,
            },
          },
          {
            breakpoint: 1800,
            settings: {
              slidesToShow: 4,
              slidesToScroll: 4,
              infinite: true,
            },
          },
          {
            breakpoint: 1264,
            settings: {
              slidesToShow: 3,
              slidesToScroll: 3,
              infinite: true,
            },
          },
          {
            breakpoint: 960,
            settings: {
              slidesToShow: 2,
              slidesToScroll: 2,
              initialSlide: 2,
            },
          },
          {
            breakpoint: 480,
            settings: {
              slidesToShow: 1,
              slidesToScroll: 1,
            },
          },
        ],
      },
      slickSettingsTwo: {
        infinite: false,
        speed: 500,
        slidesToShow: 4,
        slidesToScroll: 4,
        initialSlide: 0,
        responsive: [
          {
            breakpoint: 1700,
            settings: {
              slidesToShow: 3,
              slidesToScroll: 3,
              infinite: true,
            },
          },
          {
            breakpoint: 1264,
            settings: {
              slidesToShow: 2,
              slidesToScroll: 2,
              infinite: true,
            },
          },
          {
            breakpoint: 960,
            settings: {
              slidesToShow: 2,
              slidesToScroll: 2,
              initialSlide: 2,
            },
          },
          {
            breakpoint: 650,
            settings: {
              slidesToShow: 1,
              slidesToScroll: 1,
              initialSlide: 1,
            },
          },
        ],
      },
      slickSettingsThree: {
        infinite: false,
        speed: 500,
        slidesToShow: 6,
        slidesToScroll: 6,
        initialSlide: 0,
        responsive: [
          {
            breakpoint: 1700,
            settings: {
              slidesToShow: 6,
              slidesToScroll: 6,
              infinite: true,
            },
          },
          {
            breakpoint: 1264,
            settings: {
              slidesToShow: 4,
              slidesToScroll: 4,
              infinite: true,
            },
          },
          {
            breakpoint: 960,
            settings: {
              slidesToShow: 3,
              slidesToScroll: 3,
              initialSlide: 3,
            },
          },
          {
            breakpoint: 480,
            settings: {
              slidesToShow: 2,
              slidesToScroll: 2,
            },
          },
        ],
      },
      brandsIcon: [],
      topRatings: [],
      newArrivals: [],
      bigDiscounts: [],
      topCategories: [],
      featuredBrands: [],
      categories: [],
      heroSlider: [],
      tab: null,
      items: ["Brands", "Shops"],
    };
  },
  methods: {
    // ...mapActions(["addCart", "removeCart"]),
  }
};
</script>
<style lang="scss" scoped>
.top-categories-img {
  width: 385px;
  min-width: 100%;
  max-width: 100%;
}
</style>


