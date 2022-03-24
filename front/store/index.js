export const state = () => ({
	productList:[],
})

export const getters = {
  getCounter: (state) => {
    var countSum = 0;
    if(!state.productList){
      return 0;
    }
    for(var i=0; i < state.productList.length; i++){
      countSum += state.productList[i].quantity;
    }
    return countSum;
  },
  getTotalPrice: (state) => {
    var priceSum = 0;
    if(!state.productList){
      return 0;
    }
    for(var i=0; i < state.productList.length; i++){
      priceSum += state.productList[i].quantity * state.productList[i].price;
    }
    return priceSum;
  },
  getProductList: (state) => {
    return state.productList;
  }
}

export const mutations = {
  load_products(state, productList){
    if(!productList){
      productList = [];
    }
    state.productList = productList;
    localStorage.setItem('Cart',JSON.stringify(productList));
  },
  add_product_to_cart(state, cartItem){
    var productList = state.productList;
    var existFlg = false;
    for(var i=0; i< productList.length; i++){
      if(productList[i].product_hashid == cartItem.product_hashid){
        productList[i].quantity += 1;
        existFlg = true;
        break;
      }
    }
    if(!existFlg){
      cartItem.quantity = 1;
      productList.push(cartItem);
    }
    state.productList = productList;
    localStorage.setItem('Cart',JSON.stringify(productList));
  },
  decrease_product_of_cart(state, cartItem){
    var productList = state.productList;
    var existFlg = false;
    for(var i=0; i< productList.length; i++){
      if(productList[i].product_hashid == cartItem.product_hashid){
        productList[i].quantity -= 1;
        existFlg = true;
        break;
      }
    }
    if(existFlg){
      state.productList = productList;
      localStorage.setItem('Cart',JSON.stringify(productList));
    }
  },
  remove_product_from_cart(state, product_hashid){
    var productList = state.productList;
    for(var i=0; i< productList.length; i++){
      if(productList[i].product_hashid == product_hashid){
        productList.splice(i,1);
        break;
      }
    }
    state.productList = productList;
    localStorage.setItem('Cart',JSON.stringify(productList));
  },
  clear_cart(state){
    state.productList = [];
    localStorage.setItem('Cart',JSON.stringify([]));
  }
}

export const actions = {
  addToCart ({commit}, product) {
    // add to backend cart
    if (this.$auth.loggedIn) {
      this.$axios.$post(`api/products/${product.hashid}/add_to_cart`, {
        product_id: product.hashid,
        user_id: this.$auth.user.hashid
      }).then(() => {});
    }
    // add to store
    var cartItem = new Object();
    cartItem.product_hashid = product.hashid;
    cartItem.price = product.price;
    commit('add_product_to_cart', cartItem);
  },
}