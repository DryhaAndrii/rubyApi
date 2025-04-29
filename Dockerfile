FROM ruby:3.2.2

RUN apt-get update -qq && \
    apt-get install -y nodejs postgresql-client npm && \
    npm install -g yarn

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

CMD ["sh", "-c", "rails db:create db:migrate && rails server -b 0.0.0.0"]