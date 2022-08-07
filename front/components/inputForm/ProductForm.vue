<template>
  <v-form ref="form" v-model="valid">
    <v-text-field v-if="false" :value="hashid"></v-text-field>
    <v-switch
      color="brown lighten-1"
      :input-value="isAvailable"
      label="Available"
      @change="$emit('update:isAvailable', $event)"></v-switch>
    <v-text-field
      outlined
      dense
      color="brown lighten-3"
      :value="title"
      label="Title"
      type="text"
      :rules="titleRules"
      @input="$emit('update:title', $event)"></v-text-field>
    <v-text-field
      outlined
      dense
      color="brown lighten-3"
      :value="subTitle"
      label="Sub Title"
      :rules="subTitleRules"
      @input="$emit('update:subTitle', $event)"></v-text-field>
    <v-select
      outlined
      dense
      color="brown lighten-3"
      item-color="brown lighten-1"
      :value="categoryId"
      :items="categories"
      item-text="category"
      item-value="id"
      label="Category"
      :rules="categoryRules"
      @input="$emit('update:categoryId', $event)"></v-select>
    <v-textarea
      outlined
      dense
      color="brown lighten-3"
      :value="description"
      label="Description"
      :rules="descriptionRules"
      hint="separate description with <br>"
      @input="$emit('update:description', $event)"></v-textarea>
    <v-text-field
      outlined
      dense
      color="brown lighten-3"
      :value="price"
      label="Price"
      type="number"
      :rules="priceRules"
      @input="$emit('update:price', Number($event))"></v-text-field>
    <v-text-field
      outlined
      dense
      color="brown lighten-3"
      :value="quantity"
      label="Quantity"
      type="number"
      :rules="quantityRules"
      @input="$emit('update:quantity', Number($event))"></v-text-field>
    <v-text-field
      outlined
      dense
      color="brown lighten-3"
      :value="tags"
      label="Tags"
      hint="separate tags with commas(,)"
      @input="$emit('update:tags', $event)"></v-text-field>
    <v-text-field
      outlined
      dense
      color="brown lighten-3"
      :value="property"
      label="Property"
      hint="size, weight..."
      @input="$emit('update:property', $event)"></v-text-field>
    <div class="d-flex justify-start mb-2">
      <v-img
        v-for="photo in photoSrcs"
        :key="photo"
        :src="photo"
        height="120"
        width="120"
        max-height="120"
        max-width="120"></v-img>
    </div>
    <v-file-input
      outlined
      dense
      counter
      multiple
      prepend-icon="mdi-panorama"
      color="brown lighten-3"
      accept="image/png, image/jpeg, image/bmp"
      label="Upload image"
      placeholder="Select your image"
      @change="setImage"
      @click:clear="removeAll">
      <template #selection="{ index, text }">
        <v-chip small label close color="brown lighten-3" @click:close="removeImage(index)">
          {{ text }}
        </v-chip>
      </template>
    </v-file-input>
    <v-divider></v-divider>
    <v-list flat subheader three-line>
      <div class="d-flex justify-start mt-4">
        <v-subheader class="text-subtitle-1 font-weight-regular">Promotions</v-subheader>
        <v-btn
          class="mx-2"
          fab
          dark
          small
          color="brown lighten-1"
          @click="openPromotion()"
          @click.stop="openPromotion()">
          <v-icon dark>mdi-plus</v-icon>
        </v-btn>
      </div>
      <v-list-item-group>
        <v-list-item v-for="item in promotions" :key="item.hashid">
          <v-list-item-action>
            <v-checkbox
              v-model="item.is_active"
              :input-value="item.is_active"
              :disabled="item.start_at <= today"
              color="brown lighten-1"></v-checkbox>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title
              v-text="
                item.title + ': ' + (1 - item.discount).toFixed(2) * 100 + '%OFF'
              "></v-list-item-title>
            <v-list-item-subtitle v-text="item.start_at + '~' + item.end_at"></v-list-item-subtitle>
          </v-list-item-content>
        </v-list-item>
      </v-list-item-group>
    </v-list>
    <v-btn dark class="mr-4" color="brown lighten-1" @click="$emit('submit-product')">{{
      submitButton
    }}</v-btn>
  </v-form>
</template>

<script>
export default {
  name: "ProductForm",
  props: {
    hashid: { type: String, default: "" },
    title: { type: String, default: "" },
    subTitle: { type: String, default: "" },
    categoryId: { type: Number, default: 0 },
    description: { type: String, default: "" },
    price: { type: Number, default: 0 },
    quantity: { type: Number, default: 0 },
    tags: { type: String, default: "" },
    property: { type: String, default: "" },
    isAvailable: { type: Boolean, default: false },
    photoSrcs: { type: Array, default: () => [] },
    images: { type: Array, default: () => [] },
    promotions: { type: Array, default: () => [] },
    promotionDialog: { type: Boolean, default: false },
    isImgChange: { type: Boolean, default: false },
    submitButton: {
      type: String,
      default: "Save Changes",
    },
  },
  data() {
    return {
      valid: true,
      categories: [],
      compUrls: [],
      compDisps: [],
      today: new Date().toISOString().slice(0, 10),
      titleRules: [
        (v) => !!v || "Title is required",
        (v) => (v && v.length <= 30) || "Title must be less than 30 characters",
      ],
      subTitleRules: [
        (v) => !!v || "Sub Title is required",
        (v) => (v && v.length <= 50) || "Sub Title must be less than 50 characters",
      ],
      categoryRules: [(v) => !!v || "Category is required"],
      descriptionRules: [
        (v) => !!v || "Description is required",
        (v) => (v && v.length <= 300) || "Description must be less than 300 characters",
      ],
      priceRules: [
        (v) => !!v || "Price is required",
        (v) => (v && v > 0) || "Price should be above 0",
        (v) => (v && v <= 99999999) || "Max should not be above 99999999",
      ],
      quantityRules: [
        (v) => !!v || "Quantity is required",
        (v) => (v && v > 0) || "Quantity should be above 0",
        (v) => (v && v <= 99999999) || "Max should not be above 99999999",
      ],
    }
  },
  created() {
    this.loadCategories()
  },
  methods: {
    validate() {
      return this.$refs.form.validate()
    },
    loadCategories() {
      this.$axios.get(`/api/categories`).then((res) => {
        this.categories = res.data
      })
    },
    openPromotion() {
      this.$emit("update:promotionDialog", true)
    },
    setImage(e) {
      var that = this
      if (!e || !window.FileReader) {
        return
      }
      //clear
      that.compDisps.splice(0, this.compDisps.length)
      for (var i = 0; i < e.length; i++) {
        let reader = new FileReader()
        reader.onload = function () {
          that.compDisps.push(reader.result)
        }
        reader.readAsDataURL(e[i])
      }
      this.compUrls = e
      this.$emit("update:photoSrcs", that.compDisps)
      this.$emit("update:images", e)
      this.$emit("update:isImgChange", true)
    },
    removeImage(index) {
      this.compDisps.splice(index, 1)
      this.compUrls.splice(index, 1)
      this.$emit("update:photoSrcs", this.compDisps)
      this.$emit("update:images", this.compUrls)
    },
    removeAll() {
      this.$emit("update:photoSrcs", [])
      this.$emit("update:images", [])
    },
  },
}
</script>
