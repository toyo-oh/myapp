<template>
    <v-form>
        <v-container>
            <v-card width="400px" class="mx-auto mt-5">
                <v-card-title>
                    <h1 class="display-1">Login</h1>
                </v-card-title>
                <v-card-text>
                    <v-text-field v-model="email" type="text" label="Email" required></v-text-field>
                    <v-text-field v-model="password" type="password" label="Password" required></v-text-field>
                </v-card-text>
                <v-card-actions>
                    <v-btn class="mr-4" color="primary" @click="loginWithAuthModule">login</v-btn>
                </v-card-actions>
            </v-card>
        </v-container>
    </v-form>
</template> 

<script>
export default({
    data() {
        return{
            email:'',
            password:'',
        }
    },
    methods:{
        async loginWithAuthModule(){
            this.$auth.loginWith('local',{
                data:{
                    password: this.password,
                    email: this.email,
                },
                }).then((res) => {
                    localStorage.setItem('access-token', response.headers['access-token'])
                    localStorage.setItem('client', response.headers.client)
                    localStorage.setItem('uid', response.headers.uid)
                    localStorage.setItem('token-type', response.headers['token-type'])
                    return response
            },
            (error)=>{
                return error
            })
        }
    }
})
</script>
