export const state = () => ({
  counter: 0,
	id: "",
	name: "",
	uid: "",
	isLoggedIn: false,
	proList:[]
})

export const mutations = {
  add_cart_count(state) {
    state.counter++
  },
	login(state, user) {
		if (!user) {
			state.id = ""
			state.name = ""
			state.uid = ""
			state.isLoggedIn = false
		} else {
			state.id = user.id
			state.name = user.name
			state.uid = user.uid
			state.isLoggedIn = true
		}
	}
}