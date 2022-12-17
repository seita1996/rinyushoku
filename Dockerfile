FROM ruby:3.1.3

# RUN apt-get update -qq && \
#     apt-get install -y build-essential \
#                        libpq-dev \
#                        nodejs
ENV APP_ROOT /myapp
RUN mkdir $APP_ROOT
WORKDIR $APP_ROOT
# ADD ./Gemfile $APP_ROOT/Gemfile
# ADD ./Gemfile.lock $APP_ROOT/Gemfile.lock
# RUN bundle install
ADD . $APP_ROOT
RUN bundle install