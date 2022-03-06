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
              <v-icon> mdi-map-marker</v-icon>
            </v-avatar>
            <h2 class="mb-0">Edit My Addresses</h2>
          </div>
        </v-col>
        <v-col cols="3">
          <v-btn outlined color="brown lighten-1" class="text-capitalize ml-16" @click="rtnToList">
            Back To Addresses
          </v-btn>
        </v-col>
      </v-row>
      <v-row justify="center">
        <v-col cols="12" md="6">
          <v-form ref="form" v-model="valid">
            <v-text-field outlined dense color="brown lighten-3" v-model="receiver" label="Receiver" type="text" :rules="receiverRules"></v-text-field>
            <v-text-field outlined dense color="brown lighten-3" v-model="phoneNumber" label="PhoneNumber" type="text" :rules="phoneNumberRules"></v-text-field>
            <v-text-field outlined dense color="brown lighten-3" v-model="postCode" label="PostCode" type="text" :rules="postCodeRules"></v-text-field>
            <v-select outlined dense color="brown lighten-3" item-color="brown lighten-1" :items="prefectures" item-text="prefecture" item-value="id" v-model="prefectureId" label="Prefecture" :rules="prefectureRules"></v-select>
            <v-text-field outlined dense color="brown lighten-3" v-model="city" label="City" type="text" :rules="cityRules"></v-text-field>
            <v-textarea outlined dense color="brown lighten-3" v-model="detail" label="Detail" type="text" :rules="detailRules"></v-textarea>
            <v-btn dark class="mr-4" color="brown lighten-1" @click="editAddress">Save Changes</v-btn>
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
      prefectures: [],
      id: '',
      receiver: '',
      phoneNumber: '',
      postCode: '',
      prefectureId: '',
      city: '',
      detail: '',
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
      ],

    };
  },
  created () {
    this.loadAddress();
    this.loadPrefectures();
  },
  methods: {
    loadAddress () {
      this.$axios.$get(`/api/addresses/${this.$route.params.id}`).then((res) => {
        this.id = res.id;
        this.receiver = res.receiver;
        this.phoneNumber = res.phone_number;
        this.postCode = res.post_code;
        this.prefectureId = res.prefecture_id;
        this.city = res.city;
        this.detail = res.detail;
      }).catch((err) => {
        if (err.response && err.response.status === 401) {
          this.$router.push('/addresses');
          this.$toast.error('Unauthorized!');
        }
      });
    },
    loadPrefectures () {
      this.$axios.get(`/api/prefectures`).then((res) => {
        this.prefectures = res.data;
      });
    },
    editAddress () {
      if (this.$refs.form.validate()) {
        const formData = new FormData();
        formData.append("id", this.id);
        formData.append("receiver", this.receiver);
        formData.append("phone_number", this.phoneNumber);
        formData.append("post_code", this.postCode);
        formData.append("city", this.city);
        formData.append("prefecture_id", this.prefectureId);
        formData.append("detail", this.detail);
        this.$axios.put(`/api/addresses/${this.id}`, formData).then(() => {
          this.$router.push(`.`);
          this.$toast.show('Update address Successfully!');
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