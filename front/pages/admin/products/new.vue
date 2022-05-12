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
          <product-form
            :id="product.id"
            ref="productForm"
            :promotion-dialog.sync="promotionDialog"
            :title.sync="product.title"
            :sub-title.sync="product.subTitle"
            :category-id.sync="product.categoryId"
            :description.sync="product.description"
            :price.sync="product.price"
            :quantity.sync="product.quantity"
            :tags.sync="product.tags"
            :property.sync="product.property"
            :is-available.sync="product.isAvailable"
            :photo-srcs.sync="product.photoSrcs"
            :images.sync="product.images"
            :promotions="product.promotions"
            submit-button="Add Product"
            @submit-product="createProduct()"></product-form>
        </v-col>
      </v-row>
      <promotion-form
        ref="promotionForm"
        :promotion-dialog="promotionDialog"
        :pro-active.sync="promotion.proActive"
        :pro-title.sync="promotion.proTitle"
        :pro-discount.sync="promotion.proDiscount"
        :pro-start-at.sync="promotion.proStartAt"
        :pro-end-at.sync="promotion.proEndAt"
        @add-promotion="addPromotion()"
        @close-dialog="closeDialog()"></promotion-form>
    </div>
  </v-container>
</template>

<script>
import ProductForm from "@/components/inputForm/ProductForm"
import PromotionForm from "@/components/inputForm/PromotionForm"
export default {
  components: {
    ProductForm,
    PromotionForm,
  },
  middleware: ["auth", "admin"],
  data() {
    return {
      alertFormError: false,
      categories: [],
      product: {
        isAvailable: true,
        title: "",
        subTitle: "",
        description: "",
        price: null,
        quantity: null,
        categoryId: null,
        tags: "",
        property: "",
        photoSrcs: [],
        images: [],
        promotions: [],
      },
      promotionDialog: false,
      promotion: {
        proActive: false,
        proTitle: "",
        proDiscount: "",
        proStartAt: "",
        proEndAt: "",
        startMenu: false,
        endMenu: false,
      },
      today: new Date().toISOString().slice(0, 10),
    }
  },
  methods: {
    createProduct() {
      if (this.$refs.productForm.validate()) {
        if (this.product.images && this.product.images.length < 1) {
          this.$toast.error("At least 1 images required")
        } else if (this.product.images && this.product.images.length > 3) {
          this.$toast.error("Should not be above 3 images")
        } else {
          const config = {
            headers: {
              "content-type": "multipart/form-data",
            },
          }
          const formData = new FormData()
          formData.append("title", this.product.title)
          formData.append("sub_title", this.product.subTitle)
          formData.append("description", this.product.description)
          formData.append("price", this.product.price)
          formData.append("quantity", this.product.quantity)
          formData.append("is_available", this.product.isAvailable)
          for (var i = 0; i < this.product.images.length; i++) {
            formData.append("images[]", this.product.images[i])
          }
          formData.append("category_id", this.product.categoryId)
          formData.append("tags", this.product.tags ? this.product.tags : "")
          formData.append("property", this.product.property)
          formData.append("promotions", JSON.stringify(this.product.promotions))
          this.$axios.post("/api/admin/products", formData, config).then((res) => {
            if (res.data.code === "error") {
              this.$toast.error(res.data.message)
            } else {
              this.$toast.show(res.data.message)
              this.$router.push(`.`)
            }
          })
        }
      } else {
        this.alertFormError = true
      }
    },
    rtnToList() {
      this.$router.push(`.`)
    },
    addPromotion() {
      if (this.$refs.promotionForm.validate()) {
        // add to promotion list
        var newPro = {}
        newPro.title = this.promotion.proTitle
        newPro.discount = this.promotion.proDiscount
        newPro.start_at = this.promotion.proStartAt
        newPro.end_at = this.promotion.proEndAt
        newPro.is_active = this.promotion.proActive
        this.product.promotions.push(newPro)
        this.$refs.promotionForm.reset()
        this.promotionDialog = false
      }
    },
    closeDialog() {
      this.$refs.promotionForm.reset()
      this.promotionDialog = false
    },
  },
}
</script>
