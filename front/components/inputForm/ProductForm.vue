<template>
  <v-form ref="form" v-model="valid">
    <v-text-field :value="id" v-if="false"></v-text-field>
    <v-switch color="brown lighten-1" :value="isAvailable" @change="$emit('update:isAvailable', $event)" label="Available"></v-switch>
    <v-text-field outlined dense color="brown lighten-3" :value="title" @input="$emit('update:title', $event)" label="Title" type="text" :rules="titleRules"></v-text-field>
    <v-text-field outlined dense color="brown lighten-3" :value="subTitle" @input="$emit('update:subTitle', $event)" label="Sub Title" :rules="subTitleRules"></v-text-field>
    <v-select outlined dense color="brown lighten-3" item-color="brown lighten-1" :value="categoryId" @input="$emit('update:categoryId', $event)" :items="categories" item-text="category" item-value="id" label="Category" :rules="categoryRules"></v-select>
    <v-textarea outlined dense color="brown lighten-3" :value="description" @input="$emit('update:description', $event)" label="Description" :rules="descriptionRules" hint="separate description with <br>"></v-textarea>
    <v-text-field outlined dense color="brown lighten-3" :value="price" @input="$emit('update:price', Number($event))" label="Price" type="number" :rules="priceRules"></v-text-field>
    <v-text-field outlined dense color="brown lighten-3" :value="quantity" @input="$emit('update:quantity', Number($event))" label="Quantity" type="number" :rules="quantityRules"></v-text-field>
    <v-text-field outlined dense color="brown lighten-3" :value="tags" @input="$emit('update:tags', $event)" label="Tags" hint="separate tags with commas(,)"></v-text-field>
    <div class="d-flex justify-start mb-2">
      <v-img v-for="photo in photoSrcs" :key="photo" :src="photo" height="120" width="120" max-height="120" max-width="120"></v-img>
    </div>
    <v-file-input outlined dense counter multiple prepend-icon="mdi-panorama" color="brown lighten-3" accept="image/png, image/jpeg, image/bmp" label="Upload image" placeholder="Select your image" @change="setImage" @click:clear="removeAll">
      <template v-slot:selection="{index, text}">
        <v-chip small label close @click:close="removeImage(index)" color="brown lighten-3">
          {{text}}
        </v-chip>
      </template>
    </v-file-input>
    <v-divider></v-divider>
    <v-list flat subheader three-line>
      <div class="d-flex justify-start mt-4">
        <v-subheader class="text-subtitle-1 font-weight-regular">Promotions</v-subheader>
        <v-btn class="mx-2" fab dark small color="brown lighten-1" @click="openPromotion()" @click.stop="openPromotion()">
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
    <v-btn dark class=" mr-4" color="brown lighten-1" @click="$emit('submit-product')">{{submitButton}}</v-btn>
  </v-form>
</template>

<script>
export default {
  name: 'ProductForm',
  props: {
    id: Number,
    title: String,
    subTitle: String,
    categoryId: Number,
    description: String,
    price: Number,
    quantity: Number,
    tags: String,
    isAvailable: Boolean,
    photoSrcs: Array,
    images: Array,
    promotions: Array,
    promotionDialog: Boolean,
    isImgChange: Boolean,
    submitButton: {
      type: String,
      default: 'Save Changes'
    }
  },
  data () {
    return {
      valid: true,
      categories: [],
      compUrls: [],
      compDisps: [],
      today: new Date().toISOString().slice(0, 10),
      titleRules: [
        v => !!v || 'Title is required',
        v => (v && v.length <= 10) || 'Title must be less than 10 characters',
      ],
      subTitleRules: [
        v => !!v || 'Sub Title is required',
        v => (v && v.length <= 50) || 'Sub Title must be less than 50 characters',
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
      ]
    }
  },
  created () {
    this.loadCategories();
  },
  methods: {
    validate () {
      return this.$refs.form.validate()
    },
    loadCategories () {
      this.$axios.get(`/api/categories`).then((res) => {
        this.categories = res.data;
      });
    },
    openPromotion () {
      this.$emit('update:promotionDialog', true);
    },
    setImage (e) {
      var that = this;
      if (!e || !window.FileReader) {
        return;
      }
      //clear
      that.compDisps.splice(0, this.compDisps.length);
      for (var i = 0; i < e.length; i++) {
        let reader = new FileReader();
        reader.onload = function () {
          that.compDisps.push(reader.result)
        };
        reader.readAsDataURL(e[i]);
      }
      this.compUrls = e;
      this.$emit('update:photoSrcs', that.compDisps);
      this.$emit('update:images', e);
      this.$emit('update:isImgChange', true);
    },
    removeImage (index) {
      this.compDisps.splice(index, 1);
      this.compUrls.splice(index, 1);
      this.$emit('update:photoSrcs', this.compDisps)
      this.$emit('update:images', this.compUrls);
    },
    removeAll () {
      this.$emit('update:photoSrcs', []);
      this.$emit('update:images', []);
    }
  }
}
</script>