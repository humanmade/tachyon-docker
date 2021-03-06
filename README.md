# Archived: Please see [humanmade/tachyon](https://github.com/humanmade/tachyon)

------------------------

<table width="100%">
	<tr>
		<td align="left" width="70">
			<h1>Tachyon Docker</h1>
			Containerised Tachyon server for on the fly image resizing.
		</td>
		<td align="right" width="30%">
			<a href="https://hub.docker.com/r/humanmade/tachyon"><img src="http://dockeri.co/image/humanmade/tachyon" /></a>
		</td>
	</tr>
	<tr>
		<td>
			A <strong><a href="https://hmn.md/">Human Made</a></strong> project. Maintained by @roborourke.
		</td>
		<td align="center">
			<img src="https://hmn.md/content/themes/hmnmd/assets/images/hm-logo.svg" width="100" />
		</td>
	</tr>
</table>

## Usage

You can pull the latest image using:

```sh
docker pull humanmade/tachyon
```

Or build the Dockerfile locally using:

```sh
git clone --recursive https://github.com/humanmade/tachyon-docker.git
cd tachyon-docker
docker build --tag humanmade/tachyon ./
```

The container should always be run with the following environment variables:

```sh
docker run -d \
  --name tachyon
  -e AWS_REGION=<region> \
  -e AWS_S3_BUCKET=<bucket> \
  -e AWS_S3_ENDPOINT=<endpoint> \
  humanmade/tachyon
```

You may need to ensure that the container can see your S3 server. There
are a few ways to do this:

1. Add to the hosts file when running the container using
  ```
  --add-host <s3-host>:<ip>
  ```

2. Link the container to your s3 container and use that endpoint
  ```
  --link s3
  -e AWS_S3_ENDPOINT=http://s3:<s3-port>/
  ```

## Running on a custom port

Because the default port for the service is `8080` you can customise this for better compatibility with docker compose and reverse proxies like Traefik that assign dynamic ports for services unless specifically mapped.

Pass the `PORT` environment variable on start up like so:

```yml
services:
  tachyon:
    image: humanmade/tachyon
    environment:
      PORT: 8085
      AWS_REGION: ...
      AWS_S3_BUCKET: ...
      AWS_S3_ENDPOINT: ...
```

## Vagrant

This repo comes with a `Vagrantfile` to let you set up a local instance
or instances of Tachyon coupled to a fake S3 server courtesy of
[the fake-s3 project](https://github.com/jubos/fake-s3).

## Vagrant Plugins

You'll need to install two Vagrant plugins for this container to provision correctly.

1. `vagrant plugin install vagrant-hostsupdater`
2. `vagrant plugin install vagrant-vbguest`

Make sure to do a recursive clone of this repo:

```sh
git clone --recursive https://github.com/humanmade/tachyon-docker.git
cd tachyon-docker
vagrant up
```

You'll get 2 servers by default:

```
tchyn.srv # Tachyon image proxy server
s3.srv    # Fake S3 server
```

The S3 server can be used locally by providing the `endpoint` argument
to your AWS client be it the CLI, JS or PHP SDKs.

## WordPress

To use this with WordPress and the
[S3-Uploads](https://github.com/humanmade/S3-Uploads) plugin locally you
would add the following to your config file:

```php
define( 'S3_UPLOADS_BUCKET_URL', 'http://s3.srv/local' );
define( 'S3_UPLOADS_BUCKET', 'local' );

// These can be any non falsy value
define( 'S3_UPLOADS_KEY', 'missing' );
define( 'S3_UPLOADS_SECRET', 'missing' );
define( 'S3_UPLOADS_REGION', 'eu-west-1' );
```

And add a small script to your mu-plugins folder:

```php
<?php
add_filter( 's3_uploads_s3_client_params', function( $params ) {
    $params['endpoint'] = 'http://s3.srv/';
    $params['path_style'] = true;
    //$params['debug'] = true; // Useful if things aren't working to double check IPs etc
    return $params;
} );
```

You can then install the
[WordPress Tachyon plugin](https://github.com/humanmade/tachyon-plugin)
and configure it:

```php
// Tachyon URL
define( 'TACHYON_URL', 'http://tchyn.srv/uploads' );
```
