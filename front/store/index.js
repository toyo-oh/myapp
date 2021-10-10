export const state = () => ({
  counter: 0
})

export const mutations = {
  add_cart_count(state) {
    state.counter++
  }
}