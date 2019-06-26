FROM node:8-alpine

# Install build base
RUN apk --update add --no-cache \
	--repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
	--virtual build-deps fftw-dev gcc g++ make libc6-compat python
RUN apk --update add --no-cache \
	--repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
	vips-dev

# Get app
COPY node-tachyon /srv/tachyon/
WORKDIR /srv/tachyon
RUN npm install aws-sdk
RUN npm install --production

# Clean up
RUN apk del build-deps

# Enable env vars
ARG AWS_REGION
ARG AWS_S3_BUCKET
ARG AWS_S3_ENDPOINT
ARG PORT

# Start the reactor
EXPOSE ${PORT:-8080}
CMD node server.js ${PORT:-8080}
