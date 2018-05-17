FROM ruby:2.5.1
ARG version
COPY superbara-${version}.gem /tmp
RUN gem install /tmp/superbara-${version}.gem && rm /tmp/superbara-${version}.gem

ENTRYPOINT ["/usr/local/bundle/bin/superbara", "run", "/e2e"]
