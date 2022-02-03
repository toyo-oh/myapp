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
    <v-app-bar :clipped-left="clipped" fixed app color="brown lighten-5">
      <v-app-bar-nav-icon @click.stop="drawer = !drawer" />
      <v-btn text @click="toMain">Store</v-btn>
      <v-btn text>Product</v-btn>
      <v-spacer />
      <v-col cols="6" md="4" sm="4" xs="4">
        <v-text-field v-model="searchText" color="brown lighten-1" class="" placeholder="Searching For" filled rounded hide-details dense prepend-inner-icon="mdi-magnify" @keydown.enter="search"></v-text-field>
      </v-col>
      <!-- menu for common user -->
      <v-menu v-if="isLoggedIn&&!isAdmin" offset-y>
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
      <!-- menu for admin user-->
      <v-menu v-if="isLoggedIn&&isAdmin" offset-y>
        <template v-slot:activator="{ attrs, on }">
          <v-btn text v-bind="attrs" v-on="on">
            <v-icon>mdi-account</v-icon>
            <div style="inline">{{email}}</div>
          </v-btn>
        </template>
        <v-list>
          <v-list-item v-for="item in adminmenus" :key="item.index" link>
            <v-list-item-icon>
              <v-icon v-text="item.icon"></v-icon>
            </v-list-item-icon>
            <v-list-item-title v-text="item.text" @click="item.action"></v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
      <v-btn text v-if="!isLoggedIn" @click="login">
        <div style="inline">Log In</div>
      </v-btn>
      <v-btn text v-if="!isLoggedIn" @click="signUp">
        <div style="inline">Sign Up</div>
      </v-btn>
      <v-btn text v-if="!isAdmin" @click="displayCart">
        <!-- <v-icon>mdi-cart</v-icon>
        <div style="inline">Cart（{{$store.getters['getCounter']}}）</div> -->
        <v-badge color="red lighten-1" :content="cartCount" :value="cartCount">
          <v-icon>mdi-cart</v-icon>
        </v-badge>
      </v-btn>
      <v-btn text>
        <v-icon>mdi-help-circle-outline</v-icon>
        Help
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
        { index: 1, text: 'My Profile', icon: 'mdi-account', action: this.userInfo },
        { index: 2, text: 'My Orders', icon: ' mdi-shopping', action: this.useOrder },
        { index: 3, text: 'My Addresses', icon: ' mdi-map-marker', action: this.userAddress },
        { index: 4, text: 'My Payments', icon: ' mdi-credit-card', action: this.userPayment },
        { index: 5, text: 'My Favourites', icon: 'mdi-heart', action: '' },
        { index: 6, text: 'Log Out', icon: 'mdi-logout', action: this.logout }],
      adminmenus: [
        { index: 1, text: 'Product Management', icon: 'mdi-clipboard-outline', action: this.adminProduct },
        { index: 2, text: 'Order Management', icon: 'mdi-pin', action: this.adminOrder },
        { index: 3, text: 'Log Out', icon: 'mdi-logout', action: this.logout }],
      searchText: ''
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
    },
    isAdmin: function () {
      if (this.$auth.user)
        return this.$auth.user.is_admin;
      else
        return false;
    },
    cartCount: function () {
      return this.$store.getters['getCounter'];
    }
  },
  methods: {
    toMain () {
      this.$router.push(`/`)
    },
    login () {
      this.$router.push(`/login`)
    },
    signUp () {
      this.$router.push(`/users/new`)
    },
    userInfo () {
      this.$router.push(`/users/${this.$auth.user.id}`)
    },
    useOrder () {
      this.$router.push('/orders')
    },
    userAddress () {
      this.$router.push(`/addresses`)
    },
    userPayment () {
      this.$router.push(`/payments`)
    },
    logout () {
      this.$auth.logout();
      this.$store.commit('load_products', []);
    },
    async loadCart () {
      if (this.$auth.loggedIn) {
        const response = await this.$axios.$get(`api/cart/find_cart/${this.$auth.user.id}`);
        this.$store.commit('load_products', response.productList);
      } else {
        // array→[],object→{}(等价于new Object())
        var localCart = [];
        if (localStorage.getItem('Cart')) {
          localCart = JSON.parse(localStorage.getItem('Cart'));
        }
        this.$store.commit('load_products', localCart);
      }
    },
    displayCart () {
      this.$router.push(`/cart`)
    },
    adminProduct () {
      this.$router.push(`/admin/products`)
    },
    adminOrder () {
      this.$router.push('/admin/orders')
    },
    search (event) {
      event.preventDefault();
      if (this.searchText) {
        this.$router.push({ path: '/search', query: { value: this.searchText } });
      }
    }
  }
}
</script>
