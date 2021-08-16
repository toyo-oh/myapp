<template>
    <v-form>
        <v-container>
            <v-row justify="center">
                <v-col cols="12" md="6">
                    <v-text-field v-model="title" label="Title" type="text"></v-text-field>
                    <v-textarea v-model="description" label="Description"></v-textarea>
                    <v-text-field v-model="price" label="Price" type="number"></v-text-field>
                    <v-text-field v-model="quantity" label="Quantity" type="number"></v-text-field>
                    <v-btn class="mr-4" color="primary" @click="createProduct">create product</v-btn>
                </v-col>
            </v-row>
        </v-container>
    </v-form>    
</template>

<script>
export default({
    data(){
        return{
            title: "",
            description: "",
            price: "",
            quantity:""
        }
    },
    methods:{
        createProduct(){
            this.$axios.post('/api/admin/products',{
                title: this.title,
                description: this.description,
                price: this.price,
                quantity: this.quantity
            }).then((res)=>{
              this.$router.push(`.`)
            })
        }
    }
})
</script>