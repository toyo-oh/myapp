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
            <h2 class="mb-0 brown--text text--darken-3">Add New Payment</h2>
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
          <payment-form ref="paymentForm" :holderName.sync="payment.holderName" :cardNumber.sync="payment.cardNumber" :expirationDate.sync="payment.expirationDate" :securityCode.sync="payment.securityCode" submitButton="Create Payment" @submit-payment="createPayment()"></payment-form>
        </v-col>
      </v-row>
    </div>
  </v-container>
</template>

<script>
import PaymentForm from "@/components/inputForm/PaymentForm";
export default {
  middleware: 'auth',
  components: {
    PaymentForm
  },
  data () {
    return {
      alertFormError: false,
      payment: {
        id: '',
        holderName: '',
        cardNumber: '',
        expirationDate: '',
        securityCode: '',
      }
    };
  },
  methods: {
    createPayment () {
      if (this.$refs.paymentForm.validate()) {
        const formData = new FormData();
        formData.append("holder_name", this.payment.holderName);
        formData.append("card_number", this.payment.cardNumber);
        formData.append("expiration_date", this.payment.expirationDate);
        formData.append("security_code", this.payment.securityCode);
        formData.append("user_id", this.$auth.user.id)
        this.$axios.post("/api/payments", formData).then(() => {
          this.$router.push(`.`);
          this.$toast.show('Create payment successfully!');
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