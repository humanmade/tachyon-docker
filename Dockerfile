FROM node:4
MAINTAINER Robert O\'Rourke "rob@hmn.md"

RUN [ "mkdir",  "-p", "/srv/tachyon" ]
WORKDIR /srv/tachyon

# Install libvips
RUN [ "apt-get", "update" ]
RUN [ "apt-get", "install", "-y", "libvips", "--no-install-recommends" ]
RUN [ "apt-get", "install", "-y", "libvips-tools" ]

# Get app
COPY node-tachyon /srv/tachyon/
RUN [ "npm", "install", "node-tachyon" ]

# Enable env vars
ARG AWS_REGION
ARG AWS_S3_BUCKET
ARG AWS_S3_ENDPOINT

# Start the reactor
EXPOSE 8080
CMD [ "npm", "start" ]