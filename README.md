# myapp
<br>
**1.准备好配置文件**
   1.1构建文件目录<br>
   1.2将需要的Dockfile相关配置文件，及docker-compose.yml准备好(如下目录结构)<br>
<br>
```
myapp<br>  
  ｜-front*1<br>
    |--Dockerfile<br>
  ｜-back*4<br>
    |--Dockerfile<br>
    |--Gemfile<br>
    |--Gemfile.lock<br>
    |--entrypoint.sh<br>
  ｜- docker-compose.yml<br>
```
<br>
**2.创建image**<br>
  在myapp 目录下运行命令：<br>
  docker-compose build<br>
<br>
**3.构建Nuxt.js初始目录**<br>
  docker-compose run --rm front npx create-nuxt-app<br>
  ▲由于front文件夹非空，已有Dockerfile文件存在，所以直接执行以上命令会报错<br>
<br>
  则改为在子目录app下执行命令，在将已创建好的目录内容移动到front下<br>
  ①docker-compose run --rm front npx create-nuxt-app app<br>
  ②mv front/app/{*,.*} front<br>
  ③rmdir front/app<br>
<br>
  然后选择各种Nuxt.js的配置项<br>
<br>
  docker-compose up front<br>
  确认Nuxt是否可以启动：http://localhost:8080<br>
<br>
**4.构建Rails目录**<br>
  docker-compose run --rm back rails new . -f -d mysql --api<br>
<br>
  back/config/database.yml配置修改<br>
<br>
  config/environments/development.rb配置修改<br>
  这个不做，Nuxt.js无法通过http://back/xxx来访问Rails容器<br>
  [development.rb]<br>
  Rails.application.config.hosts << 'back'<br>
<br>
**5.git设定**
