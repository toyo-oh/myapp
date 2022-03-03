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
            <v-switch v-model="isAvailable" color="brown lighten-1" label="Available"></v-switch>
            <v-text-field outlined　dense color="brown lighten-3" v-model="title" label="Title" type="text" :rules="titleRules"></v-text-field>
            <v-text-field outlined　dense color="brown lighten-3" v-model="sub_title" label="Sub Title" :rules="subTitleRules"></v-text-field>
            <v-select outlined dense color="brown lighten-3" :items="categories" item-text="category" item-value="id" v-model="categoryId" label="Category" :rules="categoryRules"></v-select>
            <v-textarea outlined　dense color="brown lighten-3" v-model="description" label="Description" :rules="descriptionRules"></v-textarea>
            <v-text-field outlined　dense color="brown lighten-3" v-model="price" label="Price" type="number" :rules="priceRules"></v-text-field>
            <v-text-field outlined　dense color="brown lighten-3" v-model="quantity" label="Quantity" type="number" :rules="quantityRules"></v-text-field>
            <v-text-field outlined　dense color="brown lighten-3" v-model="tags" label="Tags"></v-text-field>
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

            <v-divider></v-divider>
            <v-list flat subheader three-line>
              <div class="d-flex justify-start mt-4">
                <v-subheader class="text-subtitle-1 font-weight-regular">Promotions</v-subheader>
                <v-btn class="mx-2" fab dark small color="brown lighten-1" @click="openDialog" @click.stop="promotionDialog = true">
                  <v-icon dark>mdi-plus</v-icon>
                </v-btn>
              </div>
              <v-list-item-group>
                <v-list-item v-for="item in promotions" :key="item.id">
                  <v-list-item-action>
                    <v-checkbox v-model="item.is_active" :input-value="item.is_active" :disabled="item.start_at <= today" color="brown lighten-1"></v-checkbox>
                  </v-list-item-action>
                  <v-list-item-content>
                    <v-list-item-title v-text="item.title+': '+(1-item.discount).toFixed(2)*100+'%OFF'"></v-list-item-title>
                    <v-list-item-subtitle v-text="item.start_at+'~'+item.end_at"></v-list-item-subtitle>
                  </v-list-item-content>
                </v-list-item>
              </v-list-item-group>
            </v-list>
            <v-btn dark class=" mr-4" color="brown lighten-1" @click="updateProduct">update product</v-btn>
          </v-form>
        </v-col>
      </v-row>
      <!--add new promotion dialog-->
      <v-form ref="promotionForm" v-model="promotionValid" lazy-validation>
        <v-dialog v-model="promotionDialog" max-width="500px">
          <v-card>
            <v-card-title>Add New Promotion</v-card-title>
            <v-divider></v-divider>
            <v-card-text style="height: 300px;">
              <v-switch v-model="proActive" color="brown lighten-1" label="Promotion Active"></v-switch>
              <h5>Promotion Title <sup class="brown--text">*</sup></h5>
              <v-text-field dense color="brown lighten-3" v-model="proTitle" type="text" :rules="proTitleRules"></v-text-field>
              <h5>Promotion Discount <sup class="brown--text">*</sup></h5>
              <v-text-field dense color="brown lighten-3" v-model="proDiscount" type="number" :rules="proDiscountRules"></v-text-field>
              <h5>Promotion Period <sup class="brown--text">*</sup></h5>
              <v-row>
                <v-col cols="12" sm="6" md="4">
                  <v-menu ref="startMenu" v-model="startMenu" :close-on-content-click="false" :return-value.sync="proStartAt" transition="scale-transition" offset-y min-width="auto">
                    <template v-slot:activator="{ on, attrs }">
                      <v-text-field color="brown lighten-3" v-model="proStartAt" label="Start Day" prepend-icon="mdi-calendar" readonly v-bind="attrs" v-on="on" :rules="proStartAtRules"></v-text-field>
                    </template>
                    <v-date-picker color="brown lighten-1" v-model="proStartAt" no-title scrollable>
                      <v-spacer></v-spacer>
                      <v-btn text color="brown lighten-1" @click="startMenu = false">Cancel</v-btn>
                      <v-btn text color="brown lighten-1" @click="$refs.startMenu.save(proStartAt)">OK</v-btn>
                    </v-date-picker>
                  </v-menu>
                </v-col>
                <v-col cols="12" sm="6" md="4">
                  <v-menu ref="endMenu" v-model="endMenu" :close-on-content-click="false" :return-value.sync="proEndAt" transition="scale-transition" offset-y min-width="auto">
                    <template v-slot:activator="{ on, attrs }">
                      <v-text-field color="brown lighten-3" v-model="proEndAt" label="End Day" prepend-icon="mdi-calendar" readonly v-bind="attrs" v-on="on" :rules="proEndAtRules"></v-text-field>
                    </template>
                    <v-date-picker color="brown lighten-1" v-model="proEndAt" no-title scrollable>
                      <v-spacer></v-spacer>
                      <v-btn text color="brown lighten-1" @click="endMenu = false">Cancel</v-btn>
                      <v-btn text color="brown lighten-1" @click="$refs.endMenu.save(proEndAt)">OK</v-btn>
                    </v-date-picker>
                  </v-menu>
                </v-col>
              </v-row>
            </v-card-text>
            <v-divider></v-divider>
            <v-card-actions>
              <v-btn color="brown lighten-1" text @click="addPromotion">Add</v-btn>
              <v-btn color="brown lighten-1" text @click="closeDialog">Cancel</v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </v-form>
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
      categories: [],
      promotions: [],
      promotionDialog: false,
      promotionValid: true,
      proActive: false,
      proTitle: '',
      proDiscount: '',
      proStartAt: '',
      proEndAt: '',
      startMenu: false,
      endMenu: false,
      today: new Date().toISOString().slice(0, 10),
      titleRules: [
        v => !!v || 'Title is required',
        v => (v && v.length <= 10) || 'Title must be less than 10 characters',
      ],
      subTitleRules: [
        v => !!v || 'Sub Title is required',
        v => (v && v.length <= 25) || 'Sub Title must be less than 25 characters',
      ],
      categoryRules: [
        v => !!v || 'Category is required'
      ],
      descriptionRules: [
        v => !!v || 'Description is required',
        v => (v && v.length <= 300) || 'Description must be less than 300 characters',
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
      ],
      proTitleRules: [
        v => !!v || 'Promotion Title is required',
        v => (v && v.length <= 20) || 'Promotion Title must be less than 20 characters',
      ],
      proDiscountRules: [
        v => !!v || 'Promotion Discount is required',
        v => (v && v > 0) || "Promotion Discount should be above 0",
        v => (v && v < 1) || "Max should not be above 1",
      ],
      proStartAtRules: [
        v => !!v || 'Promotion Start Day is required',
        v => (v && v > this.today) || "Promotion Start Day should be after today",
      ],
      proEndAtRules: [
        v => !!v || 'Promotion End Day is required',
        v => (v && v >= this.proStartAt) || "Promotion End Day should not before start day",
      ]
    };
  },
  asyncData ({ $axios, params }) {
    return $axios.$get(`/api/admin/products/${params.id}`).then((res) => {
      var tmpImages = [];
      if (res.product.images) {
        for (var i = 0; i < res.product.images.length; i++) {
          tmpImages.push(res.product.images[i] ? "http://localhost:3000" + res.product.images[i].thumb.url : "");
        }
      }
      return {
        id: res.product.id,
        title: res.product.title,
        sub_title: res.product.sub_title,
        categoryId: res.product.category_id,
        description: res.product.description,
        price: res.product.price,
        quantity: res.product.quantity,
        tags: res.product.tags,
        images: tmpImages,
        photoSrcs: tmpImages,
        isAvailable: res.product.is_available,
        promotions: res.product.promotions
      };
    });
  },
  created () {
    this.loadCategories();
  },
  methods: {
    loadCategories () {
      this.$axios.get(`/api/categories`).then((res) => {
        this.categories = res.data;
      });
    },
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
        formData.append("sub_title", this.sub_title);
        formData.append("description", this.description);
        formData.append("price", this.price);
        formData.append("quantity", this.quantity);
        formData.append("is_available", this.isAvailable);
        for (var i = 0; i < this.images.length; i++) {
          formData.append("image" + (i + 1), this.images[i]);
        }
        formData.append("category_id", this.categoryId);
        formData.append("tags", this.tags ? this.tags : "");
        formData.append("promotions", JSON.stringify(this.promotions));
        this.$axios.put(`api/admin/products/${this.id}`, formData, config).then((res) => {
          this.$router.push(`.`)
        })
      } else {
        this.alertFormError = true;
      }
    },
    returnToList () {
      this.$router.push(`.`)
    },
    addPromotion () {
      if (this.$refs.promotionForm.validate()) {
        // add to promotion list
        var newPro = {};
        newPro.product_id = this.id;
        newPro.title = this.proTitle;
        newPro.discount = this.proDiscount;
        newPro.start_at = this.proStartAt;
        newPro.end_at = this.proEndAt;
        newPro.is_active = this.proActive;
        this.promotions.push(newPro);
        this.$refs.promotionForm.reset();
        this.promotionDialog = false;
      }
    },
    openDialog () {
      this.promotionDialog = true;
    },
    closeDialog () {
      this.$refs.promotionForm.reset();
      this.promotionDialog = false;
    }
  }
};
</script>
