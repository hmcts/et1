FROM phusion/passenger-customizable:1.0.15
# Or, instead of the 'full' variant, use one of these:
#FROM phusion/passenger-ruby23:<VERSION>
#FROM phusion/passenger-ruby24:<VERSION>
#FROM phusion/passenger-ruby25:<VERSION>
#FROM phusion/passenger-ruby26:<VERSION>
#FROM phusion/passenger-ruby27:<VERSION>
#FROM phusion/passenger-jruby92:<VERSION>
#FROM phusion/passenger-nodejs:<VERSION>
#FROM phusion/passenger-customizable:<VERSION>

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# If you're using the 'customizable' variant, you need to explicitly opt-in
# for features.
#
# N.B. these images are based on https://github.com/phusion/baseimage-docker,
# so anything it provides is also automatically on board in the images below
# (e.g. older versions of Ruby, Node, Python).
#
# Uncomment the features you want:
#
#   Ruby support
#RUN /pd_build/ruby-2.4.*.sh
#RUN /pd_build/ruby-2.5.*.sh
#RUN /pd_build/ruby-2.6.*.sh
RUN /pd_build/ruby-2.7.*.sh
#RUN /pd_build/jruby-9.2.*.sh
#   Python support.
#RUN /pd_build/python.sh
#   Node.js and Meteor standalone support.
#   (not needed if you already have the above Ruby support)
RUN /pd_build/nodejs.sh

# ...put your own build instructions here...
RUN apt-get install -y shared-mime-info
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Adding argument support for ping.json
ARG APPVERSION=unknown
ARG APP_BUILD_DATE=unknown
ARG APP_GIT_COMMIT=unknown
ARG APP_BUILD_TAG=unknown

# Setting up ping.json variables
ENV APPVERSION ${APPVERSION}
ENV APP_BUILD_DATE ${APP_BUILD_DATE}
ENV APP_GIT_COMMIT ${APP_GIT_COMMIT}
ENV APP_BUILD_TAG ${APP_BUILD_TAG}



EXPOSE 8080

COPY --chown=app:app . /home/app/et1
USER app
ENV HOME /home/app
WORKDIR /home/app/et1
ENV RAILS_ENV=production
RUN npm install
RUN bash -lc "gem install bundler -v 1.17.3 && bundle install --jobs=5 --retry=3 --without=test development --with=production"
RUN bash -lc "DB_ADAPTOR=nulldb bundle exec rake assets:precompile RAILS_ENV=production SECRET_KEY_BASE=ijustdontcareyoureonlydoingaraketask"
CMD ["./run.sh"]
