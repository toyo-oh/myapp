<template>
  <div>
    <v-alert v-model="alertFormError" type="error" close-text="Close Alert" dismissible>
      FORM INPUT ERROR.
    </v-alert>
    <v-form ref="form" v-model="valid">
      <v-container>
        <v-row justify="center">
          <v-col cols="12" md="6">
            <v-text-field v-model="id" v-if="false"></v-text-field>
            <v-text-field v-model="title" label="Title" type="text" :rules="titleRules"></v-text-field>
            <v-textarea v-model="description" label="Description" :rules="descriptionRules"></v-textarea>
            <v-text-field v-model="price" label="Price" type="number" :rules="priceRules"></v-text-field>
            <v-text-field v-model="quantity" label="Quantity" type="number" :rules="quantityRules"></v-text-field>
            <v-img :src="photoSrc?photoSrc:image" max-height="200" max-width="200"></v-img>
            <v-file-input accept="image/png, image/jpeg, image/bmp" @change="setImage"></v-file-input>
            <v-btn class="mr-4" color="primary" @click="updateProduct">update product</v-btn>
            <v-btn class="mr-4" color="primary" @click="returnToList">cancel</v-btn>
          </v-col>
        </v-row>
      </v-container>
    </v-form>
  </div>
</template>
<script>
export default {
  middleware: ['auth', 'admin'],
  data () {
    return {
      alertFormError: false,
      valid: true,
      titleRules: [
        v => !!v || 'Title is required'
      ],
      descriptionRules: [
        v => !!v || 'Description is required'
      ],
      priceRules: [
        v => !!v || 'Price is required',
        v => (v && v > 0) || "Price should be above 0",
        v => (v && v <= 99999999) || "Max should not be above 99999999",
      ],
      quantityRules: [
        v => !!v || 'Quantity is required',
        v => (v && v > 0) || "Quantity should be above 0",
        v => (v && v <= 99999999) || "Max should not be above 99999999",
      ]
    };
  },
  asyncData ({ $axios, params }) {
    return $axios.$get(`/api/admin/products/${params.id}`).then((res) => {
      return {
        id: res.id,
        title: res.title,
        description: res.description,
        price: res.price,
        quantity: res.quantity,
        // image: `${$axios.defaults.baseURL}`+res.image.thumb.url
        // "`${$axios.defaults.baseURL}upload/1.png`"
        image: "http://localhost:3000" + res.image.thumb.url,
        photoSrc: ""
      };
    });
  },
  methods: {
    setImage (e) {
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
    updateProduct () {
      if (this.$refs.form.validate()) {
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
        this.$axios.put(`api/admin/products/${this.id}`, formData, config).then((res) => {
          this.$router.push(`.`)
        })
      } else {
        this.alertFormError = true;
      }
    },
    returnToList () {
      this.$router.push(`.`)
    }
  }
};
</script>

