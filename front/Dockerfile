FROM node:12.22.0-alpine

ENV HOME="/myapp" \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo

ENV HOST 0.0.0.0

WORKDIR ${HOME}

ARG FRONT_STRIPE_PK
ENV FRONT_STRIPE_PK ${FRONT_STRIPE_PK}
RUN echo STRIPE_PK = ${FRONT_STRIPE_PK} > .env

COPY package.json .
COPY . .

RUN apk update && \
    apk upgrade && \
    npm install -g npm@6.14.11 && \
    npm install -g @vue/cli && \
    yarn install &&\
    rm -rf /var/cache/apk/*

RUN yarn run build
EXPOSE 3000
CMD ["yarn", "start"]