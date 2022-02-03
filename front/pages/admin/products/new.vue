<template>
  <v-container>
    <div>
      <v-alert v-model="alertFormError" type="error" close-text="Close Alert" dismissible>
        There are Input Errors in the form.
      </v-alert>
      <v-row justify="center">
        <v-col cols="3">
          <div class="d-flex align-center">
            <v-avatar tile size="25" class="me-3">
              <v-icon> mdi-cube-outline</v-icon>
            </v-avatar>
            <h2 class="mb-0 brown--text text--darken-3">Add New Product</h2>
          </div>
        </v-col>
        <v-col cols="3">
          <v-btn outlined color="brown lighten-1" class="text-capitalize ml-16" @click="rtnToList">
            Back To Product List
          </v-btn>
        </v-col>
      </v-row>
      <v-row justify="center">
        <v-col cols="6" md="6">
          <v-form ref="form" v-model="valid">
            <v-text-field outlined　dense color="brown lighten-3" v-model="title" label="Title" type="text" :rules="titleRules"></v-text-field>
            <v-textarea outlined　dense color="brown lighten-3" v-model="description" label="Description" :rules="descriptionRules"></v-textarea>
            <v-text-field outlined　dense color="brown lighten-3" v-model="price" label="Price" type="number" :rules="priceRules"></v-text-field>
            <v-text-field outlined　dense color="brown lighten-3" v-model="quantity" label="Quantity" type="number" :rules="quantityRules"></v-text-field>
            <v-img :src="photoSrc?photoSrc:image" max-height="200" max-width="200"></v-img>
            <v-file-input outlined　dense color="brown lighten-3" accept="image/png, image/jpeg, image/bmp" @change="setImage"></v-file-input>
            <v-btn dark class="mr-4" color="brown lighten-1" @click="createProduct">create product</v-btn>
          </v-form>
        </v-col>
      </v-row>
    </div>
  </v-container>
</template>

<script>
export default {
  middleware: ['auth', 'admin'],
  data () {
    return {
      alertFormError: false,
      valid: true,
      title: "",
      description: "",
      price: "",
      quantity: "",
      image: "",
      photoSrc: "",
      titleRules: [
        v => !!v || 'Title is required',
        v => (v && v.length <= 20) || 'Title must be less than 20 characters',
      ],
      descriptionRules: [
        v => !!v || 'Description is required',
        v => (v && v.length <= 100) || 'Description must be less than 100 characters',
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
    createProduct () {
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
        this.$axios.post("/api/admin/products", formData, config).then((res) => {
          this.$router.push(`.`);
        });
      } else {
        this.alertFormError = true;
      }
    },
    rtnToList () {
      this.$router.push(`.`);
    }
  },
};
</script>