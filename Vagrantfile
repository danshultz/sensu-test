# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  def build(config, name, port_suffix)
    config.vm.define(name) { |c|
      c.vm.hostname = "#{name}-vagrant"

      c.vm.box = 'precise64'
      c.vm.box_url = 'http://cloud-images.ubuntu.com/precise/current/precise-server-cloudimg-vagrant-amd64-disk1.box'
      c.vm.network :private_network, ip: "33.33.33.#{port_suffix}"

      # config.vm.network :public_network
      c.ssh.max_tries = 40
      c.ssh.timeout   = 120
      c.berkshelf.enabled = true
      c.omnibus.chef_version = :latest
      yield(c)  if block_given?
    }
  end

  build(config, "sensu-server", 11) { |c|
    c.vm.provider("virtualbox") { |v|
      v.customize ["modifyvm", :id, "--memory", 1024]
    }

    c.vm.provision :chef_solo do |chef|
      chef.data_bags_path = "data_bags"
      chef.json = { }

      chef.run_list = [
        "recipe[sensu-test::server]",
      ]
    end
  }

  build(config, "sensu-client", 12) { |c|
    c.vm.provision :chef_solo do |chef|
      chef.data_bags_path = "data_bags"
      chef.json = {
        :sensu => {
          :rabbitmq => {
            :host => "33.33.33.11"
          },
          :redis => {
            :host => "33.33.33.11"
          },
          :api => {
            :host => "33.33.33.11"
          }
        }
      }

      chef.run_list = [
        "recipe[sensu-test::client]",
        "recipe[sensu-test::cron_check]",
      ]
    end
  }

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to exclusively install and copy to Vagrant's shelf.
  # config.berkshelf.only = []

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to skip installing and copying to Vagrant's shelf.
  # config.berkshelf.except = []

end
