export const state = () => ({
	id: "",
	email: "",
	token: "",
	isLoggedIn: false
})
export const getters = {
	getUserId: (state)=>{
		return state.id
	},
  getUserEmail: (state) => {
    return state.email
  },
	getLogInState: (state)=>{
		return state.isLoggedIn
	},
	getUserToken: (state)=>{
		return state.token
	}
}
export const mutations = {
	login(state, user) {
		state.id = user.id
		state.email = user.email
		state.token = user.token
		state.isLoggedIn = true
	}
}