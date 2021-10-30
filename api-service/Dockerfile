# Use the official Debian-hosted Python image
FROM python:3.8-slim-buster

ARG DEBIAN_PACKAGES="build-essential git"

# Prevent apt from showing prompts
ENV DEBIAN_FRONTEND=noninteractive

# Python wants UTF-8 locale
ENV LANG=C.UTF-8

# Tell pipenv where the shell is. This allows us to use "pipenv shell" as a
# container entry point.
ENV PYENV_SHELL=/bin/bash

# Tell Python to disable buffering so we don't lose any logs.
ENV PYTHONUNBUFFERED=1

# Ensure we have an up to date baseline, install dependencies and
# create a user so we don't run the app as root
RUN set -ex; \
    # We create a bunch of directories that are need, they don't know why
    for i in $(seq 1 8); do mkdir -p "/usr/share/man/man${i}"; done && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends $DEBIAN_PACKAGES && \
    apt-get clean && \

    # Remove temp directories
    rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir --upgrade pip && \
    pip install pipenv && \

    # NOTE: A best practise to use
    # Your container runs as root by default, for security you want to
    # create a new user called "app" and use that to run everything you want
    useradd -ms /bin/bash app -d /home/app -u 1000 -p "$(openssl passwd -1 Passw0rd)" && \
    mkdir -p /app && \
    chown app:app /app

# Expose port
EXPOSE 9000

# Switch to the new user
USER app
WORKDIR /app

# Install python packages
# Make the new user 'app' owner of the Pipfile and Pipfile.lock
ADD --chown=app:app Pipfile Pipfile.lock /app/

RUN pipenv sync

# Add the rest of the source code. This is done last so we don't invalidate all
# layers when we change a line of code.
# NOTE: Here set the user to the folder
ADD --chown=app:app . /app

# Entry point
# NOTE: In this scenario we tells docker to instead of running the container directly:
# go to another shell script which will:
# - Put in some logic like differentiating between dev and production
# - Define some commands we can use
ENTRYPOINT ["/bin/bash","./docker-entrypoint.sh"]