export default ({ $axios, redirect, error}) => {
    // request
    $axios.onRequest((config) => {
      // console.log(config)
    })
    // response
    $axios.onResponse((config) => {
      // console.log(config)
    })  
    // error
    $axios.onError((err) => {
      const code = parseInt(err.response && err.response.status)
      console.log(code);
      if (code === 401) {
        return redirect("/login");
      }else if(code === 404){
        return redirect("/error/404");
      }else{
        return redirect("/error/500");
      }
    })
  }