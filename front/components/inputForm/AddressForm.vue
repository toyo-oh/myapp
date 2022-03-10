<template>
  <v-form ref="form" v-model="valid">
    <v-text-field outlined dense color="brown lighten-3" :value="receiver" @input="$emit('update:receiver', $event)" label="Receiver" type="text" :rules="receiverRules"></v-text-field>
    <v-text-field outlined dense color="brown lighten-3" :value="phoneNumber" @input="$emit('update:phoneNumber', $event)" label="PhoneNumber" type="text" :rules="phoneNumberRules"></v-text-field>
    <v-text-field outlined dense color="brown lighten-3" :value="postCode" @input="$emit('update:postCode', $event)" label="PostCode" type="text" :rules="postCodeRules"></v-text-field>
    <v-select outlined dense color="brown lighten-3" item-color="brown lighten-1" :items="prefectures" item-text="prefecture" item-value="id" :value="prefectureId" @change="$emit('update:prefectureId', $event)" label="Prefecture" :rules="prefectureRules"></v-select>
    <v-text-field outlined dense color="brown lighten-3" :value="city" @input="$emit('update:city', $event)" label="City" type="text" :rules="cityRules"></v-text-field>
    <v-textarea outlined dense color="brown lighten-3" :value="detail" @input="$emit('update:detail', $event)" label="Detail" type="text" :rules="detailRules"></v-textarea>
    <v-btn dark class="mr-4" color="brown lighten-1" @click="$emit('submit-address')">{{submitButton}}</v-btn>
  </v-form>
</template>

<script>
export default {
  name: 'AddressForm',
  props: {
    receiver: String,
    phoneNumber: String,
    postCode: String,
    prefectureId: Number,
    city: String,
    detail: String,
    submitButton: {
      type: String,
      default: 'Save Changes'
    }
  },
  data () {
    return {
      valid: true,
      prefectures: [],
      receiverRules: [
        v => !!v || 'Receiver is required',
        v => (v && v.length <= 20) || 'Receiver must be less than 20 characters',
      ],
      phoneNumberRules: [
        v => !!v || 'Phone Number is required',
        v => /^\d{2,4}-\d{2,4}-\d{4}$/.test(v) || 'Phone Number must be valid',
      ],
      postCodeRules: [
        v => !!v || 'Post Code is required',
        v => /^[0-9]{3}-[0-9]{4}$/.test(v) || 'Post Code must be valid',
      ],
      prefectureRules: [
        v => !!v || 'Prefectures is required'
      ],
      cityRules: [
        v => !!v || 'City is required'
      ],
      detailRules: [
        v => !!v || 'Detail is required',
        v => (v && v.length <= 100) || 'Detail Address must be less than 100 characters',
      ]
    }
  },
  created () {
    this.loadPrefectures();
  },
  methods: {
    validate () {
      return this.$refs.form.validate()
    },
    loadPrefectures () {
      this.$axios.get(`/api/prefectures`).then((res) => {
        this.prefectures = res.data;
      });
    },
  }
}
</script>