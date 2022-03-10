<template>
  <v-form ref="form" v-model="valid">
    <v-text-field outlined dense color="brown lighten-3" :value="holderName" @input="$emit('update:holderName', $event)" label="HolderName" type="text" :rules="holderNameRules"></v-text-field>
    <v-text-field outlined dense color="brown lighten-3" :value="cardNumber" @input="$emit('update:cardNumber', $event)" label="CardNumber" type="text" :rules="cardNumberRules"></v-text-field>
    <v-text-field outlined dense color="brown lighten-3" :value="expirationDate" @input="$emit('update:expirationDate', $event)" label="ExpiratonDate" type="text" :rules="expirationDateRules"></v-text-field>
    <v-text-field outlined dense color="brown lighten-3" :value="securityCode" @input="$emit('update:securityCode', $event)" label="SecurityCode" type="text" :rules="securityCodeRules"></v-text-field>
    <v-btn dark class="mr-4" color="brown lighten-1" @click="$emit('submit-payment')">{{submitButton}}</v-btn>
  </v-form>
</template>

<script>
export default {
  name: 'PaymentForm',
  props: {
    // payment: Object,
    holderName: String,
    cardNumber: String,
    expirationDate: String,
    securityCode: String,
    submitButton: {
      type: String,
      default: 'Save Changes'
    }
  },
  data () {
    return {
      valid: true,
      holderNameRules: [
        v => !!v || 'Holder Name is required',
        v => (v && v.length <= 20) || 'Holder Name must be less than 20 characters',
      ],
      cardNumberRules: [
        v => !!v || 'Card Number is required',
        v => /^[0-9]{16}$/.test(v) || 'Card Number must be valid',
      ],
      expirationDateRules: [
        v => !!v || 'Expiration Date is required',
        v => /^[1-2]\d{3}((0[1-9])|(1[0-2]))$/.test(v) || 'Expiration Date must be valid',
      ],
      securityCodeRules: [
        v => !!v || 'Security Code is required',
        v => /^[0-9]{3}$/.test(v) || 'Security Code must be less than 100 characters',
      ]
    }
  },
  methods: {
    validate () {
      return this.$refs.form.validate()
    }
  }
}
</script>