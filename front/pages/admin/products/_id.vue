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
            <h2 class="mb-0">Edit Product</h2>
          </div>
        </v-col>
        <v-col cols="3">
          <v-btn outlined color="brown lighten-1" class="text-capitalize ml-16" @click="returnToList">
            Back To Product List
          </v-btn>
        </v-col>
      </v-row>
      <v-row justify="center">
        <v-col cols="6">
          <v-form ref="form" v-model="valid">
            <v-text-field v-model="id" v-if="false"></v-text-field>
            <v-text-field outlined　dense color="brown lighten-3" v-model="title" label="Title" type="text" :rules="titleRules"></v-text-field>
            <v-textarea outlined　dense color="brown lighten-3" v-model="description" label="Description" :rules="descriptionRules"></v-textarea>
            <v-text-field outlined　dense color="brown lighten-3" v-model="price" label="Price" type="number" :rules="priceRules"></v-text-field>
            <v-text-field outlined　dense color="brown lighten-3" v-model="quantity" label="Quantity" type="number" :rules="quantityRules"></v-text-field>
            <div class="d-flex justify-start mb-2">
              <v-img v-for="photo in photoSrcs" :key="photo" :src="photo" height="120" width="120" max-height="120" max-width="120"></v-img>
            </div>
            <v-file-input outlined　dense counter multiple color="brown lighten-3" accept="image/png, image/jpeg, image/bmp" label="Upload image" placeholder="Select your image" :rules="imagesRules" @change="setImage" @click:clear="removeAll">
              <template v-slot:selection="{index,text}">
                <v-chip small label close @click:close="removeImage(index)" color="brown lighten-3">
                  {{text}}
                </v-chip>
              </template>
            </v-file-input>
            <v-btn dark class="mr-4" color="brown lighten-1" @click="updateProduct">update product</v-btn>
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
      photoSrcs: [],
      images: [],
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
      ],
      imagesRules: [
        v => !!v || 'Image is required',
        v => (v && v.length > 0) || "At least 1 images required",
        v => (v && v.length <= 3) || "Should not be above 3 images",
      ]
    };
  },
  asyncData ({ $axios, params }) {
    return $axios.$get(`/api/admin/products/${params.id}`).then((res) => {
      var tmp_images = [];
      if (res.images) {
        for (var i = 0; i < res.images.length; i++) {
          tmp_images.push(res.images[i] ? "http://localhost:3000" + res.images[i].thumb.url : "");
        }
      }
      return {
        id: res.id,
        title: res.title,
        description: res.description,
        price: res.price,
        quantity: res.quantity,
        // image: `${$axios.defaults.baseURL}`+res.image.thumb.url
        // "`${$axios.defaults.baseURL}upload/1.png`"
        images: tmp_images,
        photoSrcs: tmp_images
      };
    });
  },
  methods: {
    setImage (e) {
      var that = this;
      if (!e || !window.FileReader) {
        return;
      }
      //clear
      that.photoSrcs.splice(0, this.photoSrcs.length);
      for (var i = 0; i < e.length; i++) {
        let reader = new FileReader();
        reader.onload = function () {
          that.photoSrcs.push(reader.result)
        };
        reader.readAsDataURL(e[i]);
      }
      this.images = e;
    },
    removeImage (index) {
      this.photoSrcs.splice(index, 1);
      this.images.splice(index, 1);
    },
    removeAll () {
      this.photoSrcs.splice(0, this.photoSrcs.length);
      this.images.splice(0, this.images.length);
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
        for (var i = 0; i < this.images.length; i++) {
          formData.append("image" + (i + 1), this.images[i]);
        }
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
