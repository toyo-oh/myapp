export const state = () => ({
  counter: 0,
	productList:[]
})

export const mutations = {
  add_cart_count(state) {
    state.counter++
  },
  load_products(state, productList){
    state.productList = productList;
    var sum = 0;
    for(var i=0; i<productList.length; i++){
      sum += productList[i].quantity;
    }
    state.counter = sum;
    localStorage.setItem('Cart',productList);
  }
}