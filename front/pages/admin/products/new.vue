<template>
  <v-form>
    <v-container>
      <v-row justify="center">
        <v-col cols="12" md="6">
          <v-text-field
            v-model="title"
            label="Title"
            type="text"
          ></v-text-field>
          <v-textarea v-model="description" label="Description"></v-textarea>
          <v-text-field
            v-model="price"
            label="Price"
            type="number"
          ></v-text-field>
          <v-text-field
            v-model="quantity"
            label="Quantity"
            type="number"
          ></v-text-field>
          <v-file-input
            accept="image/png, image/jpeg, image/bmp"
            @change="setImage"
          ></v-file-input>
          <v-btn class="mr-4" color="primary" @click="createProduct"
            >create product</v-btn
          >
        </v-col>
      </v-row>
    </v-container>
  </v-form>
</template>

<script>
export default {
  data() {
    return {
      title: "",
      description: "",
      price: "",
      quantity: "",
      image: "",
    };
  },
  methods: {
    setImage(e) {
      this.image = e;
    },
    createProduct() {
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
    },
  },
};
</script>