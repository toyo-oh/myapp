export const state = () => ({
  counter: 0,
	proList:[]
})

export const mutations = {
  add_cart_count(state) {
    state.counter++
  }
}