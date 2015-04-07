VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos65-x86_64-20140116"
  config.vbguest.auto_update = false

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 4096] # RAM allocated to each VM
    vb.customize ["modifyvm", :id, "--cpus", 2]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  config.vm.provision :shell, :path => "bootstrap.sh"
  config.vm.provision :shell, :path => "blueprint-1-node.sh"
  config.vm.provision :shell, :path => "accumulo-init.sh"

  config.vm.define :ambari do |ambari|
    ambari.vm.hostname = "ambari"
    ambari.vm.network :private_network, ip: "192.168.64.101"
    ambari.vm.network "forwarded_port", guest: 50095, host: 50095

  end

end
