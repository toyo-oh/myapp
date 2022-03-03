export default ({ $axios, redirect, error}) => {
    // request
    $axios.onRequest((config) => {
      console.log(config)
    })
    // response
    $axios.onResponse((config) => {
      console.log(config)
    })  
    // error
    $axios.onError((e) => {
      // const code = parseInt(error.response && error.response.status)
      // if (code === 401) {
      //   return redirect("/login");
      // }else if(code === 404){
      //   // return redirect("/error/404");
      //   error({ statusCode: 404, message: 'Post not found' });
      // }else{
      //   return redirect("/error/500");
      // }
    })
  }