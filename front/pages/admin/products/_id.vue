<template>
  <v-form>
    <v-container>
      <v-row justify="center">
        <v-col cols="12" md="6">
          <v-text-field v-model="id" v-if="false"></v-text-field>         
          <v-text-field v-model="title" label="Title" type="text"></v-text-field>
          <v-textarea v-model="description" label="Description"></v-textarea>
          <v-text-field v-model="price" label="Price" type="number"></v-text-field>
          <v-text-field v-model="quantity" label="Quantity" type="number"></v-text-field>
          <v-img :src="photoSrc?photoSrc:image" max-height="200" max-width="200"></v-img>
          <v-file-input accept="image/png, image/jpeg, image/bmp" @change="setImage"></v-file-input>
          <v-btn class="mr-4" color="primary" @click="updateProduct">update product</v-btn>
          <v-btn class="mr-4" color="primary" @click="returnToList">cancel</v-btn>
        </v-col>
      </v-row>
    </v-container>
  </v-form>
</template>
<script>
export default {
  asyncData({ $axios, params }) {
    return $axios.$get(`/api/admin/products/${params.id}`).then((res) => {
      return {
        id: res.id,
        title: res.title,
        description: res.description,
        price: res.price,
        quantity: res.quantity,
        // image: `${$axios.defaults.baseURL}`+res.image.thumb.url
        // "`${$axios.defaults.baseURL}upload/1.png`"
        image: "http://localhost:3000"+res.image.thumb.url,
        photoSrc:""
      };
    });
  },
  methods:{
      setImage(e) {
        var that = this;
        // 判断浏览器是否支持 FileReader
        if (!e || !window.FileReader) {
            alert("您的设备不支持图片预览功能，如需该功能请升级您的设备！");
            return;
        }
        let reader = new FileReader();
        // 这里是最关键的一步，转换就在这里
        if (e) {
            reader.readAsDataURL(e); 
        }
        reader.onload = function () {
            that.photoSrc = this.result
        };
        // 设置文件
        this.image = e;
      },
      updateProduct(){
        const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      };
      const formData = new FormData();
      formData.append("title", this.title);
      formData.append("description", this.description);
      formData.append("price", this.price);
      formData.append("quantity", this.quantity);
      formData.append("image", this.image);
      this.$axios.put(`api/admin/products/${this.id}`,formData,config).then((res)=>{
              this.$router.push(`.`)
          })
      },
      returnToList(){
        this.$router.push(`.`)
      }
  }
};
</script>

