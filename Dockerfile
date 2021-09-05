FROM reactnativecommunity/react-native-android:4 AS base
FROM base AS compiler
# set unicode
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
# create user (non-root)
RUN set -ex; \
    gem install bundler \
      && bundle install \
      && bundle exec fastlane build_android; \
    useradd -ms /bin/bash reactnative \
      && chown reactnative:reactnative $ANDROID_HOME -R
# copy bashrc
COPY .bashrc /home/reactnative/.bashrc
# set default user
USER reactnative
# workdir
WORKDIR /home/reactnative
