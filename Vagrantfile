# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  ## base machine 
  config.vm.box = "hashicorp/precise32"
  ## provisioning script
  config.vm.provision :shell, :path => "bootstrap.sh"
  config.vm.network "forwarded_port", guest: 80, host: 8080
end
