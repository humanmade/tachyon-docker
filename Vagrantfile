# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

current_dir = File.dirname(File.expand_path(__FILE__))
settings    = YAML.load_file("#{current_dir}/config.yaml")

Vagrant.configure(2) do |config|

  config.vm.box = "debian/jessie64"

  # Tachyon runs on tchyn.srv
  # S3 runs on s3.srv
  config.vm.network :private_network, ip: settings['ip']
  config.vm.hostname = settings['hostname']
  config.hostsupdater.aliases = settings['aliases'].values

  # Shared folders
  config.vm.synced_folder ".", "/app"

  # Install docker
  config.vm.provision "docker" do |d|
  end

  # Clean up before provision
  config.vm.provision "shell", inline: <<-SHELL
    # clean up containers prior to provisioning
    echo "Removing running containers..."
    docker rm --force `docker ps -qa`
    echo "Done!"
  SHELL

  # Spin up the VM with tachyon & S3 containers
  config.vm.provision "docker" do |d|

    # Nginx proxy
    d.pull_images "jwilder/nginx-proxy"
    d.run "proxy",
      image: "jwilder/nginx-proxy",
      args: "-p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro"

    # Fake S3
    d.pull_images "smaj/spurious-s3"
    d.run "s3",
      image: "smaj/spurious-s3",
      args: "-p 4569:4569 -v /app/s3:/var/data/fake_s3 \
        -e VIRTUAL_HOST=#{settings['aliases']['s3']}"

    # Tachyon servers
    d.build_image "/app",
      args: "-t 'humanmade/tachyon-server'"
    settings['instances'].each { |host,args|
      config.hostsupdater.aliases << host
      d.run "#{host}",
        image: "humanmade/tachyon-server",
        args: " \
          -e VIRTUAL_HOST=#{host} \
          -e AWS_REGION=#{args['region']} \
          -e AWS_S3_BUCKET=#{args['bucket']} \
          -e AWS_S3_ENDPOINT=#{args['endpoint']} \
          --add-host #{settings['aliases']['s3']}:#{settings['ip']}"
    }
  end

end
