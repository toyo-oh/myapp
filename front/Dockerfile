FROM node:12.22.0-alpine

ENV HOME="/myapp" \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo

WORKDIR ${HOME}

RUN apk update && \
    apk upgrade && \
    npm install -g npm@6.14.11 && \
    npm install -g @vue/cli

ENV HOST 0.0.0.0
EXPOSE 3000