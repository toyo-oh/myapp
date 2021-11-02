<template>
  <v-app dark>
    <v-navigation-drawer v-model="drawer" :mini-variant="miniVariant" :clipped="clipped" fixed app>
      <v-list nav dense>
        <v-list-item-group v-model="group" active-class="deep-purple--text text--accent-4">
          <v-list-item>
            <v-list-item-icon>
              <v-icon>mdi-home</v-icon>
            </v-list-item-icon>
            <v-list-item-title>Home</v-list-item-title>
          </v-list-item>
          <v-list-item>
            <v-list-item-icon>
              <v-icon>mdi-account</v-icon>
            </v-list-item-icon>
            <v-list-item-title>Account</v-list-item-title>
          </v-list-item>
        </v-list-item-group>
      </v-list>
    </v-navigation-drawer>
    <v-app-bar :clipped-left="clipped" fixed app color="deep-purple">
      <v-app-bar-nav-icon @click.stop="drawer = !drawer" />
      <!-- <v-btn icon @click.stop="miniVariant = !miniVariant">
        <v-icon>mdi-{{ `chevron-${miniVariant ? 'right' : 'left'}` }}</v-icon>
      </v-btn> -->
      <!-- <v-btn icon @click.stop="clipped = !clipped">
        <v-icon>mdi-application</v-icon>
      </v-btn> -->
      <!-- <v-btn icon @click.stop="fixed = !fixed">
        <v-icon>mdi-minus</v-icon>
      </v-btn> -->
      <v-btn text @click="toMain">Store</v-btn>
      <v-btn text>Product</v-btn>
      <!-- <v-toolbar-title v-text="title" /> -->
      <v-spacer />
      <v-menu v-if="isLoggedIn" offset-y>
        <template v-slot:activator="{ attrs, on }">
          <v-btn text v-bind="attrs" v-on="on">
            <v-icon>mdi-account</v-icon>
            <div style="inline">{{email}}</div>
          </v-btn>
        </template>
        <v-list>
          <v-list-item v-for="item in actmenus" :key="item" link>
            <v-list-item-title v-text="item" @click="logout"></v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
      <v-btn text v-if="!isLoggedIn">
        <div style="inline">Login</div>
      </v-btn>
      <v-btn text v-if="!isLoggedIn">
        <div style="inline">Sign In</div>
      </v-btn>
      <v-btn text>
        <v-icon>mdi-cart</v-icon>
        <div style="inline">Cart（{{counter}}）</div>
      </v-btn>
      <v-btn icon>
        <v-icon>mdi-magnify</v-icon>
      </v-btn>
      <!-- <v-btn icon @click.stop="rightDrawer = !rightDrawer">
        <v-icon>mdi-menu</v-icon>
      </v-btn> -->
    </v-app-bar>
    <v-main>
      <v-container>
        <nuxt />
      </v-container>
    </v-main>
    <!-- <v-navigation-drawer v-model="rightDrawer" :right="right" temporary fixed>
      <v-list>
        <v-list-item @click.native="right = !right">
          <v-list-item-action>
            <v-icon light>
              mdi-repeat
            </v-icon>
          </v-list-item-action>
          <v-list-item-title>Switch drawer (click me)</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-navigation-drawer> -->
    <v-footer :absolute="!fixed" app>
      <span>&copy; {{ new Date().getFullYear() }}</span>
    </v-footer>
  </v-app>
</template>

<script>
import store from "../store/index.js";
export default {
  data () {
    return {
      clipped: false,
      drawer: false,
      fixed: false,
      group: false,
      items: [
        {
          icon: 'mdi-apps',
          title: 'Welcome',
          to: '/'
        },
        {
          icon: 'mdi-chart-bubble',
          title: 'Inspire',
          to: '/inspire'
        }
      ],
      miniVariant: false,
      right: true,
      rightDrawer: false,
      title: 'Store',
      actmenus: ['Log Out']
    }
  },
  created () {
    this.loadCart();
  },
  computed: {
    counter: function () {
      return this.$store.state.counter
    },
    email: function () {
      return this.$auth.user.email;
    },
    isLoggedIn: function () {
      return this.$auth.loggedIn;
    }
  },
  methods: {
    toMain () {
      this.$router.push(`/`)
    },
    logout () {
      this.$auth.logout();
      this.$store.commit('load_products', {});
    },
    async loadCart () {
      if (this.$auth.loggedIn) {
        const response = await this.$axios.$get(`api/cart/find_cart/${this.$auth.user.id}`);
        this.$store.commit('load_products', response.productList);
      } else {
        var localCart = localStorage.getItem('Cart') || {};
        this.$store.commit('load_products', localCart);
      }
    }
  }
}
</script>
