import colors from "vuetify/es5/util/colors"

export default {
  // Disable server-side rendering: https://go.nuxtjs.dev/ssr-mode
  ssr: false,

  // Global page headers: https://go.nuxtjs.dev/config-head
  head: {
    titleTemplate: "%s - myapp",
    title: "myapp",
    htmlAttrs: {
      lang: "en",
    },
    meta: [
      { charset: "utf-8" },
      { name: "viewport", content: "width=device-width, initial-scale=1" },
      { hid: "description", name: "description", content: "" },
    ],
    link: [{ rel: "icon", type: "image/x-icon", href: "/favicon.ico" }],
    script: [
      {
        src: "https://js.stripe.com/v3",
      },
    ],
  },

  env: {
    STRIPE_PK: process.env.STRIPE_PK,
    AFTERSHIP_PK: process.env.AFTERSHIP_PK,
  },

  // Global CSS: https://go.nuxtjs.dev/config-css
  css: [],

  // Plugins to run before rendering page: https://go.nuxtjs.dev/config-plugins
  plugins: ["plugins/axios"],

  // Auto import components: https://go.nuxtjs.dev/config-components
  components: true,

  // Modules for dev and build (recommended): https://go.nuxtjs.dev/config-modules
  buildModules: [
    // https://go.nuxtjs.dev/vuetify
    "@nuxtjs/vuetify",
    // "@nuxtjs/eslint-module",
  ],

  // Modules: https://go.nuxtjs.dev/config-modules
  modules: ["@nuxtjs/axios", "@nuxtjs/auth", "@nuxtjs/toast", "@nuxtjs/dotenv"],

  axios: {
    // baseURL: 'http://back:3000',
    // browserBaseURL: 'http://back:3000',
    proxy: true,
  },

  proxy: {
    "/api/": { target: "http://back:3000", pathRewrite: { "^/api/": "/" } },
    "/tracking_api/": {
      target: "http://nanoappli.com/tracking/api",
      changeOrigin: true,
      pathRewrite: { "^/tracking_api/": "/" },
    },
  },

  auth: {
    cookie: {
      options: {
        maxAge: 60 * 60 * 24 * 1,
      },
    },
    localStorage: false,
    redirect: {
      login: "/login",
      logout: "/login",
      callback: false,
      home: "/home",
    },
    strategies: {
      local: {
        endpoints: {
          login: { url: "/api/login", method: "post", propertyName: "jwt" },
          user: {
            url: "/api/user/current_user",
            method: "get",
            propertyName: "user",
          },
          logout: false,
          // refresh: { url: '/api/user/refresh', method: 'post' },
        },
        // refreshToken: {
        //   property: 'refresh_token',
        //   data: 'refresh_token',
        //   maxAge: 60 * 60 * 24 * 30
        // },
      },
    },
  },

  toast: {
    position: "top-center",
    duration: 3000,
    theme: "outline",
  },

  // Vuetify module configuration: https://go.nuxtjs.dev/config-vuetify
  vuetify: {
    customVariables: ["~/assets/variables.scss"],
    theme: {
      dark: false,
      themes: {
        dark: {
          primary: colors.blue.darken2,
          accent: colors.grey.darken3,
          secondary: colors.amber.darken3,
          info: colors.teal.lighten1,
          warning: colors.amber.base,
          error: colors.deepOrange.accent4,
          success: colors.green.accent3,
        },
      },
    },
  },

  // Build Configuration: https://go.nuxtjs.dev/config-build
  build: {},
}
