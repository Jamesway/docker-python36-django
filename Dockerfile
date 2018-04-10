# includes setuptools and wheel
FROM python:3.6-slim-stretch

MAINTAINER James <j@mesway.io>

RUN BUILD_DEPS='autoconf \
                build-essential \
                git \
                libssl-dev' \
    && apt-get update \
    && apt-get install -yqq $RUN_DEPS $BUILD_DEPS --no-install-recommends \
    && pip install django \
    && apt-get purge -y --auto-remove $BUILD_DEPS \
    && rm -rf /var/lib/apt/lists/*

ENV APP_PATH /code
ENV PATH $APP_PATH:$PATH
WORKDIR $APP_PATH

CMD ["/bin/bash"]
