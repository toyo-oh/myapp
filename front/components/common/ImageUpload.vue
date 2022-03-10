<template>
  <v-file-input outlined dense counter multiple prepend-icon="mdi-panorama" color="brown lighten-3" accept="image/png, image/jpeg, image/bmp" label="Upload image" placeholder="Select your image" @change="setImage" @click:clear="removeAll">
    <template v-slot:selection="{index, text}">
      <v-chip small label close @click:close="removeImage(index)" color="brown lighten-3">
        {{text}}
      </v-chip>
    </template>
  </v-file-input>
</template>

<script>
export default {
  name: 'ImageUpload',
  props: {
    images: Array,
    photoSrcs: Array
  },
  data () {
    return {
      compUrls: [],
      compDisps: []
    }
  },
  methods: {
    setImage (e) {
      var that = this;
      if (!e || !window.FileReader) {
        return;
      }
      //clear
      that.compDisps.splice(0, this.compDisps.length);
      for (var i = 0; i < e.length; i++) {
        let reader = new FileReader();
        reader.onload = function () {
          that.compDisps.push(reader.result)
        };
        reader.readAsDataURL(e[i]);
      }
      this.compUrls = e;
      this.$emit('update:photoSrcs', that.compDisps);
      this.$emit('update:images', e);
    },
    removeImage (index) {
      this.compDisps.splice(index, 1);
      this.compUrls.splice(index, 1);
      this.$emit('update:photoSrcs', this.compDisps)
      this.$emit('update:images', this.compUrls);
    },
    removeAll () {
      this.$emit('update:photoSrcs', []);
      this.$emit('update:images', []);
    },

  }
}
</script>