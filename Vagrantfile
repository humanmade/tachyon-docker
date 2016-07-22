# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "phusion/ubuntu-14.04-amd64"

  # Tachyon runs on localhost:8181
  config.vm.network "forwarded_port", guest: 8080, host: 8181

  # S3 runs on localhost:8282
  config.vm.network "forwarded_port", guest: 8282, host: 8282

  # Clean up before provision
  config.vm.provision "shell", inline: <<-SHELL
    # clean up containers prior to provisioning
    echo "Removing running containers..."
    docker rm --force `docker ps -qa`
    echo "Done!"
  SHELL

  # Spin up the VM with tachyon & S3 containers
  config.vm.provision "docker" do |d|

    # Fake S3
    d.pull_images "smaj/spurious-s3"
    d.run "fakes3",
      image: "smaj/spurious-s3",
      args: "-p 8282:4569"

    # Tachyon
    d.build_image "/vagrant",
      args: '-t "tachyon"'
    d.run "tachyon",
      args: "-p 8181:8080 --link fakes3:s3.amazonaws.com"

  end

end
