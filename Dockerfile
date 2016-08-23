FROM node:slim
MAINTAINER Robert O\'Rourke "rob@hmn.md"

# Install libvips
RUN [ "apt-get", "update" ]
RUN [ "apt-get", "install", "-y", "make", "g++", "python", "libvips", "--no-install-recommends" ]

# Get app
COPY node-tachyon /srv/tachyon/
WORKDIR /srv/tachyon
RUN [ "npm", "install" ]

# Enable env vars
ARG AWS_REGION
ARG AWS_S3_BUCKET
ARG AWS_S3_ENDPOINT

# Start the reactor
EXPOSE 8080
CMD [ "node", "server.js" ]
