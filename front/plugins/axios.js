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
    $axios.onError((err) => {
      const status = parseInt(err.response && err.response.status)
      const message = err.response && err.response.data.message;
      if (status === 401) {
        return redirect("/login");
      }else if(status === 404){
        return redirect("/error/404");
      }else{
        return redirect("/error/500");
      }
    })
  }