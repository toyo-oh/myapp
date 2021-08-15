<template>
    <h1>Hello,{{title}}</h1>
</template>
<script>
export default {
  asyncData({ $axios, params }) {
    return $axios.$get(`/api/admin/products/${params.id}`)
      .then((res) => {
        return { title: res.title }
      })
  }
}
</script>

