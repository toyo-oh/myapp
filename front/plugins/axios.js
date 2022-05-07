// context api : https://www.nuxtjs.cn/api/context
// nuxtjs plugins: https://nuxtjs.org/docs/directory-structure/plugins
export default (context) => {
  // request
  context.$axios.onRequest((config) => {
    console.log(config)
  })
  // response
  context.$axios.onResponse((config) => {
    console.log(config)
  })
  // error
  context.$axios.onError((err) => {
    const status = parseInt(err.response && err.response.status)
    const message = err.response && err.response.data.message
    if (status === 401) {
      if (message === "Token has expired") {
        context.$auth.logout()
        context.store.commit("load_products", [])
      }
      context.$toast.error(message)
      return context.redirect("/login")
    } else if (status === 404) {
      return context.redirect("/error/404")
    } else {
      return context.redirect("/error/500")
    }
  })
}
