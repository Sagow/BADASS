Vagrant.configure("2") do |config|
  config.vm.box = "generic/debian12"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.memory = 4096
    vb.cpus = 2
  end

  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y xfce4 lightdm

    sudo mkdir -p /etc/lightdm/lightdm.conf.d
    cat <<EOF | sudo tee /etc/lightdm/lightdm.conf.d/50-autologin.conf
[Seat:*]
autologin-user=vagrant
autologin-user-timeout=0
EOF

    # TODO: https://docs.gns3.com/docs/getting-started/installation/linux/
  SHELL

  config.ssh.forward_agent = true
  config.vm.synced_folder ".", "/vagrant"
end
