<template>
  <v-form ref="form" v-model="valid" lazy-validation>
    <v-dialog :value="promotionDialog" max-width="500px">
      <v-card>
        <v-card-title>Add New Promotion</v-card-title>
        <v-divider></v-divider>
        <v-card-text style="height: 300px">
          <v-switch
            :value="proActive"
            color="brown lighten-1"
            label="Promotion Active"
            @change="$emit('update:proActive', $event)"></v-switch>
          <h5>Promotion Title <sup class="brown--text">*</sup></h5>
          <v-text-field
            dense
            color="brown lighten-3"
            :value="proTitle"
            type="text"
            :rules="proTitleRules"
            @input="$emit('update:proTitle', $event)"></v-text-field>
          <h5>Promotion Discount <sup class="brown--text">*</sup></h5>
          <v-text-field
            dense
            color="brown lighten-3"
            :value="proDiscount"
            type="number"
            :rules="proDiscountRules"
            @input="$emit('update:proDiscount', $event)"></v-text-field>
          <h5>Promotion Period <sup class="brown--text">*</sup></h5>
          <v-row>
            <v-col cols="12" sm="6" md="4">
              <v-menu
                ref="startMenu"
                v-model="startMenu"
                :close-on-content-click="false"
                :return-value.sync="startMenu"
                transition="scale-transition"
                offset-y
                min-width="auto">
                <template #activator="{ on, attrs }">
                  <v-text-field
                    color="brown lighten-3"
                    :value="startAtDisp"
                    label="Start Day"
                    prepend-icon="mdi-calendar"
                    v-bind="attrs"
                    :rules="proStartAtRules"
                    v-on="on"></v-text-field>
                </template>
                <v-date-picker
                  v-model="selectStartAt"
                  color="brown lighten-1"
                  no-title
                  scrollable
                  @input="updStartAt($event)">
                </v-date-picker>
              </v-menu>
            </v-col>
            <v-col cols="12" sm="6" md="4">
              <v-menu
                ref="endMenu"
                v-model="endMenu"
                :close-on-content-click="false"
                :return-value.sync="endMenu"
                transition="scale-transition"
                offset-y
                min-width="auto">
                <template #activator="{ on, attrs }">
                  <v-text-field
                    color="brown lighten-3"
                    :value="endAtDisp"
                    label="End Day"
                    prepend-icon="mdi-calendar"
                    v-bind="attrs"
                    :rules="proEndAtRules"
                    v-on="on"></v-text-field>
                </template>
                <v-date-picker
                  v-model="selectEndAt"
                  color="brown lighten-1"
                  no-title
                  scrollable
                  @input="updEndAt($event)">
                </v-date-picker>
              </v-menu>
            </v-col>
          </v-row>
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions>
          <v-btn color="brown lighten-1" text @click="$emit('add-promotion')">Add</v-btn>
          <v-btn color="brown lighten-1" text @click="$emit('close-dialog')">Cancel</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-form>
</template>

<script>
export default {
  name: "PromotionForm",
  props: {
    promotionDialog: { type: Boolean, default: false },
    proActive: { type: Boolean, default: false },
    proTitle: { type: String, default: "" },
    proDiscount: { type: String, default: "" },
    proStartAt: { type: String, default: "" },
    proEndAt: { type: String, default: "" },
  },
  data() {
    return {
      valid: true,
      startMenu: false,
      endMenu: false,
      selectStartAt: null,
      selectEndAt: null,
      today: new Date().toISOString().slice(0, 10),
      proTitleRules: [
        (v) => !!v || "Promotion Title is required",
        (v) => (v && v.length <= 20) || "Promotion Title must be less than 20 characters",
      ],
      proDiscountRules: [
        (v) => !!v || "Promotion Discount is required",
        (v) => (v && v > 0) || "Promotion Discount should be above 0",
        (v) => (v && v < 1) || "Max should not be above 1",
      ],
      proStartAtRules: [
        (v) => !!v || "Promotion Start Day is required",
        (v) => (v && v > this.today) || "Promotion Start Day should be after today",
      ],
      proEndAtRules: [
        (v) => !!v || "Promotion End Day is required",
        (v) => (v && v >= this.selectStartAt) || "Promotion End Day should not before start day",
      ],
    }
  },
  computed: {
    startAtDisp() {
      return this.selectStartAt
    },
    endAtDisp() {
      return this.selectEndAt
    },
  },
  methods: {
    validate() {
      return this.$refs.form.validate()
    },
    reset() {
      this.$refs.form.reset()
    },
    updStartAt(event) {
      this.startMenu = false
      this.$emit("update:proStartAt", event)
    },
    updEndAt(event) {
      this.endMenu = false
      this.$emit("update:proEndAt", event)
    },
  },
}
</script>
