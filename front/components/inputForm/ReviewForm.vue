<template>
  <v-dialog :value="reviewDialog" max-width="500px">
    <v-card>
      <v-card-title>Write a Review for this product</v-card-title>
      <v-divider></v-divider>
      <v-card-text style="height: 300px">
        <br />
        <h5 class="mb-3">Your Rating <sup class="brown--text">*</sup></h5>
        <v-rating
          v-model="rate"
          color="amber"
          background-color="grey lighten-2"
          class="mb-3"
          dense
          half-increments
          size="20"></v-rating>
        <h5 class="mb-3">Your Review <sup class="brown--text">*</sup></h5>
        <v-textarea
          v-model="comment"
          color="brown lighten-1"
          class="mb-3"
          outlined
          background-color="white">
        </v-textarea>
      </v-card-text>
      <v-divider></v-divider>
      <v-card-actions>
        <v-btn color="brown lighten-1" text @click="reviewProduct(reviewPid)">Submit</v-btn>
        <v-btn color="brown lighten-1" text @click="closeDialog()">Cancel</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  name: "ReviewForm",
  props: {
    reviewDialog: { type: Boolean, default: false },
    reviewPid: { type: String, default: "" },
  },
  data() {
    return {
      valid: true,
      comment: "",
      rate: 0,
    }
  },
  methods: {
    reviewProduct(phashid) {
      this.$emit("update:reviewDialog", false)
      if (this.$auth.loggedIn) {
        this.$axios
          .$post("api/reviews", {
            product_id: phashid,
            user_id: this.$auth.user.hashid,
            comment: this.comment,
            rate: this.rate,
          })
          .then(() => {
            this.$toast.show("Review the product successfully!")
            this.rate = 0
            this.comment = ""
          })
      } else {
        this.$toast.error("Please login in before review the product!")
      }
    },
    closeDialog() {
      this.rate = 0
      this.comment = ""
      this.$emit("update:reviewDialog", false)
    },
  },
}
</script>
