FROM ruby:2.5.3

# Install gems
ENV APP_HOME /email
ENV HOME /root
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/
RUN bundle install

# Upload source
COPY . $APP_HOME

# Start server
ENV PORT 3000
ENV BIND '0.0.0.0'
EXPOSE 3000
CMD ["ruby", "app.rb"]