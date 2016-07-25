# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "debian/jessie64"

  # Tachyon runs on tachyon.local
  # S3 runs on s3.local
  config.vm.network :private_network, ip: "192.168.80.80"
  config.vm.hostname = "tachyon.server"
  config.hostsupdater.aliases = [
    "tachyon.dev",
    "s3.dev",
  ]

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
    d.run "fakes3",
      image: "smaj/spurious-s3",
      args: "-p 4569:4569 -e VIRTUAL_HOST=s3.dev"

    # Tachyon
    d.build_image "/vagrant",
      args: '-t "tachyon"'
    d.run "tachyon",
      args: "-e VIRTUAL_HOST=tachyon.dev -e ENV=dev --link fakes3:s3.amazonaws.com"

  end

end
