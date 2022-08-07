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
              <v-icon>mdi-credit-card</v-icon>
            </v-avatar>
            <h2 class="mb-0">Edit My Payments</h2>
          </div>
        </v-col>
        <v-col cols="3">
          <v-btn outlined color="brown lighten-1" class="text-capitalize ml-16" @click="rtnToList">
            Back To Payments
          </v-btn>
        </v-col>
      </v-row>
      <v-row justify="center">
        <v-col cols="6">
          <payment-form
            ref="paymentForm"
            :holder-name.sync="payment.holderName"
            :card-number.sync="payment.cardNumber"
            :expiration-date.sync="payment.expirationDate"
            :security-code.sync="payment.securityCode"
            submit-button="Save Changes"
            @submit-payment="editPayment()"></payment-form>
        </v-col>
      </v-row>
    </div>
  </v-container>
</template>

<script>
import PaymentForm from "@/components/inputForm/PaymentForm"
export default {
  components: {
    PaymentForm,
  },
  middleware: "auth",
  data() {
    return {
      alertFormError: false,
      payment: {
        holderName: "",
        cardNumber: "",
        expirationDate: "",
        securityCode: "",
      },
    }
  },
  created() {
    this.loadPayment()
  },
  methods: {
    loadPayment() {
      this.$axios
        .$get(`/api/payments/${this.$route.params.id}`)
        .then((res) => {
          this.payment.hashid = res.hashid
          this.payment.holderName = res.holder_name
          this.payment.cardNumber = res.card_number
          this.payment.expirationDate = res.expiration_date
          this.payment.securityCode = res.security_code
        })
        .catch((err) => {
          if (err.response && err.response.status === 401) {
            this.$router.push("/payments")
            this.$toast.error("Unauthorized!")
          }
        })
    },
    editPayment() {
      if (this.$refs.paymentForm.validate()) {
        const formData = new FormData()
        formData.append("hashid", this.payment.hashid)
        formData.append("holder_name", this.payment.holderName)
        formData.append("card_number", this.payment.cardNumber)
        formData.append("expiration_date", this.payment.expirationDate)
        formData.append("security_code", this.payment.securityCode)
        this.$axios.put(`/api/payments/${this.payment.hashid}`, formData).then(() => {
          this.$router.push(`.`)
          this.$toast.show("Update payment successfully!")
        })
      } else {
        this.alertFormError = true
      }
    },
    rtnToList() {
      this.$router.push(`.`)
    },
  },
}
</script>
