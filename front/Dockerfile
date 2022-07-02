FROM node:12.22.0-alpine

ENV HOME="/myapp" \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo

WORKDIR ${HOME}

RUN apk update && \
    apk upgrade && \
    npm install -g npm@6.14.11 && \
    npm install -g @vue/cli

ARG FRONT_STRIPE_PK
ENV FRONT_STRIPE_PK ${FRONT_STRIPE_PK}
RUN echo "FRONT_STRIPE_PK: $FRONT_STRIPE_PK"

RUN yarn run build
EXPOSE 3000
CMD ["yarn", "start"]