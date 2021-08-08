# myapp


**1.准备好配置文件**

   1.1构建文件目录

   1.2将需要的Dockfile相关配置文件，及docker-compose.yml准备好(如下目录结构)

```
myapp    
  ｜-front*1  
    |--Dockerfile  
  ｜-back*4  
    |--Dockerfile  
    |--Gemfile  
    |--Gemfile.lock  
    |--entrypoint.sh  
  ｜- docker-compose.yml  
```


**2.创建image**  
  在myapp 目录下运行命令：
  docker-compose build  



**3.构建Nuxt.js初始目录**  
  docker-compose run --rm front npx create-nuxt-app  
  ▲由于front文件夹非空，已有Dockerfile文件存在，所以直接执行以上命令会报错  

  则改为在子目录app下执行命令，在将已创建好的目录内容移动到front下  
  ①docker-compose run --rm front npx create-nuxt-app app  
  ②mv front/app/{*,.*} front  
  ③rmdir front/app  

  然后选择各种Nuxt.js的配置项  

  docker-compose up front  
  确认Nuxt是否可以启动：http://localhost:8080  



**4.构建Rails目录**  
  docker-compose run --rm back rails new . -f -d mysql --api  

  back/config/database.yml配置修改  

  config/environments/development.rb配置修改  
  这个不做，Nuxt.js无法通过http://back/xxx来访问Rails容器  
  [development.rb]  
  Rails.application.config.hosts << 'back'  



**5.git设定**
