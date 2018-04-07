FROM ruby:2.5.1

RUN gem install superbara
WORKDIR /tests
ENTRYPOINT ["/usr/local/bundle/bin/superbara", "start"]
