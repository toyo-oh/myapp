export default ({ $axios, redirect, error}) => {
    // request
    $axios.onRequest((config) => {
      // console.log(config)
    })
    // response
    $axios.onResponse((config) => {
      console.log(config)
    })
    // error
    $axios.onError((err) => {
      const code = parseInt(err.response && err.response.status)
      const message = err.response && err.response.data.message;
      if (code === 401) {
        // if account or password is incorrect, do not need to redirect
        if(message!="Account or password is incorrect"){
          return redirect("/login");
        }
      }else if(code === 404){
        return redirect("/error/404");
      }else{
        return redirect("/error/500");
      }
    })
  }