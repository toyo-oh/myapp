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
        <v-col cols="12" md="6">
          <v-form ref="form" v-model="valid">
            <v-text-field outlined　dense color="brown lighten-3" v-model="holderName" label="HolderName" type="text" :rules="holderNameRules"></v-text-field>
            <v-text-field outlined　dense color="brown lighten-3" v-model="cardNumber" label="CardNumber" type="text" :rules="cardNumberRules"></v-text-field>
            <v-text-field outlined　dense color="brown lighten-3" v-model="expirationDate" label="ExpiratonDate" type="text" :rules="expiratonDateRules"></v-text-field>
            <v-text-field outlined　dense color="brown lighten-3" v-model="securityCode" label="SecurityCode" type="text" :rules="securityCodeRules"></v-text-field>
            <v-btn dark class="mr-4" color="brown lighten-1" @click="editPayment">Save Changes</v-btn>
          </v-form>
        </v-col>
      </v-row>
    </div>
  </v-container>
</template>

<script>
export default {
  middleware: 'auth',
  data () {
    return {
      valid: true,
      alertFormError: false,
      id: '',
      holderName: '',
      cardNumber: '',
      expirationDate: '',
      securityCode: '',
      holderNameRules: [
        v => !!v || 'Holder Name is required',
        v => (v && v.length <= 20) || 'Holder Name must be less than 20 characters',
      ],
      cardNumberRules: [
        v => !!v || 'Card Number is required',
        v => /^[0-9]{16}$/.test(v) || 'Card Number must be valid',
      ],
      expiratonDateRules: [
        v => !!v || 'Expiraton Date is required',
        v => /^[1-2]\d{3}((0[1-9])|(1[0-2]))$/.test(v) || 'Expiraton Date must be valid',
      ],
      securityCodeRules: [
        v => !!v || 'Security Code is required',
        v => /^[0-9]{3}$/.test(v) || 'Security Code must be less than 100 characters',
      ],
    };
  },
  created () {
    this.loadPayment();
  },
  methods: {
    loadPayment () {
      this.$axios.$get(`/api/payments/${this.$route.params.id}`).then((res) => {
        this.id = res.id;
        this.holderName = res.holder_name;
        this.cardNumber = res.card_number;
        this.expirationDate = res.expiration_date;
        this.securityCode = res.security_code;
      }).catch((err) => {
        if (err.response && err.response.status === 401) {
          this.$router.push('/payments');
          this.$toast.error('Unauthorized!');
        }
      });
    },
    editPayment () {
      if (this.$refs.form.validate()) {
        const formData = new FormData();
        formData.append("id", this.id);
        formData.append("holder_name", this.holderName);
        formData.append("card_number", this.cardNumber);
        formData.append("expiration_date", this.expirationDate);
        formData.append("security_code", this.securityCode);
        this.$axios.put(`/api/payments/${this.id}`, formData).then(() => {
          this.$router.push(`.`);
          this.$toast.show('Update payment successfully!');
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