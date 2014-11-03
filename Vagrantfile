# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
echo "Installing RVM GPG Keys"
gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3

echo "Installing RVM"
curl -s -L get.rvm.io | bash -s stable

echo "Installing RVM dependencies"
sudo ~/.rvm/bin/rvm requirements

echo "Updating environment variables"
source ~/.bashrc
source ~/.bash_profile

echo "Installing ruby"
rvm install ruby-1.9.3

echo "Installing GIT"
if which yum; then
  sudo yum install -y git
elif which apt-get; then
  sudo apt-get install git
fi
SCRIPT

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provision "shell", privileged: false, inline: $script

  config.vm.define "centos" do |centos|
    centos.vm.box = "centos-64-x64"
  end

  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.box = "puppet-ubuntu"
  end
end
