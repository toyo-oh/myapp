FROM ruby:2.6.9
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -y nodejs yarn \
    && apt-get install -y cron \
    && apt-get install -y vim \
    && mkdir /myapp

ENV HOME="/myapp" \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo
WORKDIR ${HOME}
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . ${HOME}

ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY ${RAILS_MASTER_KEY}
RUN echo "RAILS_MASTER_KEY: $RAILS_MASTER_KEY"

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

RUN bundle exec whenever --update-crontab
CMD ["bundle", "exec", "rails", "s", "-e", "production"]
