# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  ## base machine 
  config.vm.box = "ubuntu/trusty64"
  ## provisioning script
  config.vm.provision :shell, :path => "bootstrap.sh"
  config.vm.synced_folder '.', '/vagrant', disabled: false

  config.vm.provider "virtualbox" do |vb|
    vb.name = "vagrant-conduit"
  end
  
end
