FROM node:4
MAINTAINER Robert O\'Rourke "rob@hmn.md"

RUN [ "mkdir",  "-p", "/srv/tachyon" ]
WORKDIR /srv/tachyon

# Install libvips
RUN [ "apt-get", "update" ]
RUN [ "apt-get", "install", "-y", "libvips", "--no-install-recommends" ]
RUN [ "apt-get", "install", "-y", "libvips-tools" ]

# Get app
COPY package.json /srv/tachyon/
RUN [ "npm", "install" ]

# Copy config in
COPY config.json /srv/tachyon/

# Start the reactor
EXPOSE 8080
CMD [ "npm", "start" ]