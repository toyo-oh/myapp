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
    localStorage.setItem('Cart',JSON.stringify(productList));
  },
  add_product_to_cart(state, cartItem){
    var productList = state.productList;
    var existFlg = false;
    for(var i=0; i< productList.length; i++){
      if(productList[i].product_id == cartItem.product_id){
        productList[i].quantity += 1;
        existFlg = true;
        break;
      }
    }
    if(!existFlg){
      cartItem.quantity = 1;
      productList.push(cartItem);
    }
    state.counter += 1;
    localStorage.setItem('Cart',JSON.stringify(productList));
  },
  decrease_product_of_cart(state, cartItem){
    var productList = state.productList;
    var existFlg = false;
    for(var i=0; i< productList.length; i++){
      if(productList[i].product_id == cartItem.product_id){
        productList[i].quantity -= 1;
        existFlg = true;
        break;
      }
    }
    if(existFlg){
      state.counter -= 1;
      localStorage.setItem('Cart',JSON.stringify(productList));
    }
  },
  remove_product_from_cart(state,product_id){
    var productList = state.productList;
    for(var i=0; i< productList.length; i++){
      if(productList[i].product_id == product_id){
        state.counter -= productList[i].quantity;
        productList.splice(i,1);
        break;
      }
    }
    localStorage.setItem('Cart',JSON.stringify(productList));
  }
}