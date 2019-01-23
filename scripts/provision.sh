#!/usr/bin/env bash
# Install needed software and basic configs

CONSUL=1.3.0
CONSULTEMPLATE=0.19.5
ENVCONSUL=0.7.3
VAULT=0.11.4

PKG="wget unzip"
which ${PKG} &>/dev/null || {
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y ${PKG}
}

# check consul binary
which consul || {
  pushd /usr/local/bin
  [ -f consul_${CONSUL}_linux_amd64.zip ] || {
    sudo wget -q https://releases.hashicorp.com/consul/${CONSUL}/consul_${CONSUL}_linux_amd64.zip
  }
  sudo unzip consul_${CONSUL}_linux_amd64.zip
  sudo chmod +x consul
  popd
}

# check consul-template binary
which consul-template || {
  pushd /usr/local/bin
  [ -f consul-template_${CONSULTEMPLATE}_linux_amd64.zip ] || {
    sudo wget -q https://releases.hashicorp.com/consul-template/${CONSULTEMPLATE}/consul-template_${CONSULTEMPLATE}_linux_amd64.zip
  }
  sudo unzip consul-template_${CONSULTEMPLATE}_linux_amd64.zip
  sudo chmod +x consul-template
  popd
}

# check envconsul binary
which envconsul || {
  pushd /usr/local/bin
  [ -f envconsul_${ENVCONSUL}_linux_amd64.zip ] || {
    sudo wget -q https://releases.hashicorp.com/envconsul/${ENVCONSUL}/envconsul_${ENVCONSUL}_linux_amd64.zip
  }
  sudo unzip envconsul_${ENVCONSUL}_linux_amd64.zip
  sudo chmod +x envconsul
  popd
}

# check vault binary
which vault &>/dev/null || {
  pushd /usr/local/bin
  [ -f vault_${VAULT}_linux_amd64.zip ] || {
    sudo wget -q https://releases.hashicorp.com/vault/${VAULT}/vault_${VAULT}_linux_amd64.zip
  }
  sudo unzip vault_${VAULT}_linux_amd64.zip
  sudo chmod +x vault
  popd
}

# Set .bash_profile to load .bashrc
grep '\.bashrc' ~/.bash_profile &>/dev/null || \
echo -e "\nif [ -f ~/.bashrc ]; then\n\tsource ~/.bashrc\nfi" | \
sudo tee -a ~/.bash_profile

grep '\.bashrc' /vagrant/home/.bash_profile &>/dev/null || \
echo -e "\nif [ -f ~/.bashrc ]; then\n\tsource ~/.bashrc\nfi" | \
sudo tee -a /home/vagrant/.bash_profile

sudo chown vagrant /home/vagrant/.bash_profile