<template>
    <v-form>
        <v-container>
            <v-row justify="center">
                <v-col cols="12" md="6">
                    <v-text-field v-model="name" type="text" label="Name" required></v-text-field>
                    <v-text-field v-model="password" type="password" label="Password" required></v-text-field>
                    <v-text-field v-model="email" type="text" label="Email" required></v-text-field>
                    <v-btn class="mr-4" color="primary" @click="createUser">submit</v-btn>
                    <v-btn @click="clear">clear</v-btn>
                </v-col>
            </v-row>
        </v-container>
    </v-form>
</template> 

<script>
export default({
    data() {
        return{
            name:'',
            password:'',
            email:''
        }
    },
    methods:{
        clear(){
            this.name='',
            this.password='',
            this.email=''
        },
        createUser(){
            this.$axios.post('/api/users',{
                    name: this.name,
                    password: this.password,
                    email: this.email
                }).then((res) => {
                    this.$router.push(`${res.data.id}`)
            })
        }
    }
})
</script>
