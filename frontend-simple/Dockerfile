
# A node mini OS to run or JS based project
# Use a base image slim version fo Debian with node installed
FROM node:14.9.0-buster-slim

# Update baseline and ensure we don't run the app as root.
RUN set -ex; \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends openssl && \
    npm install -g http-server && \

    # Create a user so we don't run the app as root, add a user called app
    useradd -ms /bin/bash app -d /home/app -G sudo -u 2000 -p "$(openssl passwd -1 Passw0rd)" && \
    mkdir -p /app && \

    # Set the owner of the directory as the newly created user
    chown app:app /app

# Expose port 8080 from the container to the outside for the web server
EXPOSE 8080

# Switch to the new user

# Set the the working directory to app aka "cd app"
USER app
WORKDIR /app

# Set bash as entrypoint, so the CLI (I believe) to interact with
ENTRYPOINT ["/bin/bash"]