Vagrant::Config.run do |config|
  config.vm.box = "lucid64"
  config.vm.box_url = "http://files.vagrantup.com/lucid64.box"

  config.vm.forward_port 80,   5001
  config.vm.forward_port 8888, 5002

  config.vm.provision :shell, :path => "setup.sh"

  if local_bosh_src = ENV['BOSH_SRC']
    config.vm.share_folder "bosh-src", "/bosh", local_bosh_src
  end
end
