# includes setuptools and wheel
FROM python:3.6-slim-stretch

MAINTAINER James <j@mesway.io>
# based on vimagick/scrapyd and robcherry/docker-chromedriver
# purging wget removes required run time packages including python

# scrapy and selenium
RUN BUILD_DEPS='autoconf \
                build-essential \
                git \
                libssl-dev' \
    && apt-get update \
    && apt-get install -yqq $RUN_DEPS $BUILD_DEPS --no-install-recommends \
    && pip install django \
    && apt-get purge -y --auto-remove $BUILD_DEPS \
    && rm -rf /var/lib/apt/lists/*

# entrypoint causes a "starting container process caused chdir to cwd" error with -w /working/dir

WORKDIR /code

CMD ["/bin/bash"]
