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
      <v-btn text @click="toMain">Store</v-btn>
      <v-btn text>Product</v-btn>
      <v-spacer />
      <v-menu v-if="isLoggedIn" offset-y>
        <template v-slot:activator="{ attrs, on }">
          <v-btn text v-bind="attrs" v-on="on">
            <v-icon>mdi-account</v-icon>
            <div style="inline">{{email}}</div>
          </v-btn>
        </template>
        <v-list>
          <v-list-item v-for="item in actmenus" :key="item.index" link>
            <v-list-item-icon>
              <v-icon v-text="item.icon"></v-icon>
            </v-list-item-icon>
            <v-list-item-title v-text="item.text" @click="item.action"></v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
      <v-btn text v-if="!isLoggedIn" @click="login">
        <div style="inline">Login</div>
      </v-btn>
      <v-btn text v-if="!isLoggedIn" @click="signIn">
        <div style="inline">Sign In</div>
      </v-btn>
      <v-btn text @click="displayCart">
        <v-icon>mdi-cart</v-icon>
        <div style="inline">Cart（{{$store.getters['getCounter']}}）</div>
      </v-btn>
      <v-btn icon>
        <v-icon>mdi-magnify</v-icon>
      </v-btn>
    </v-app-bar>
    <v-main>
      <v-container>
        <nuxt />
      </v-container>
    </v-main>
    <v-footer :absolute="!fixed" app>
      <span>&copy; {{ new Date().getFullYear() }}</span>
    </v-footer>
  </v-app>
</template>

<script>
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
      actmenus: [
        { index: 1, text: 'User Info', icon: 'mdi-account', action: this.userInfo },
        { index: 2, text: 'My Order', icon: 'mdi-checkbox-multiple-marked', action: '' },
        { index: 3, text: 'My Address', icon: 'mdi-home-map-marker', action: this.userAddress },
        { index: 4, text: 'My Favourite', icon: 'mdi-heart', action: '' },
        { index: 5, text: 'Log Out', icon: 'mdi-logout', action: this.logout }]
    }
  },
  created () {
    this.loadCart();
  },
  computed: {
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
    login () {
      this.$router.push(`/login`)
    },
    signIn () {
      this.$router.push(`/users/new`)
    },
    userInfo () {
      this.$router.push(`/users/${this.$auth.user.id}`)
    },
    userAddress () {
      this.$router.push(`/addresses`)
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
    },
    displayCart () {
      this.$router.push(`/cart`)
    }
  }
}
</script>
