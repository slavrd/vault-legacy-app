#!/usr/bin/env bash
# start and setup Vault

# set vault log destination
if [ -d /vagrant ]; then
  [ -d /vagrant/logs ] || mkdir /vagrant/logs
  LOG="/vagrant/logs/vault_${HOSTNAME}.log"
else
  LOG="vault.log"
fi

# kill past instance
sudo killall vault &>/dev/null

# delete old token if present
[ -f /root/.vault-token ] && sudo rm /root/.vault-token

# start vault
/usr/local/bin/vault server  -dev -dev-listen-address=0.0.0.0:8200  &> ${LOG} &
echo vault started
sleep 3 

# make sure the current token is used
export VAULT_TOKEN="`sudo cat /root/.vault-token`"

# set vault address 
export VAULT_ADDR="http://127.0.0.1:8200"

# enable database secrets engine in Vaults
vault secrets enable database > /dev/null && \
    echo "vault database secrets engine enabled"

# configure access to the database for vault
vault write database/config/mysql-db \
    plugin_name=mysql-database-plugin \
    connection_url="{{username}}:{{password}}@tcp(127.0.0.1:3306)/" \
    allowed_roles="app_role" \
    username="vaultuser" \
    password="vaultpass" > /dev/null

# configure role for credentials granted by vault
vault write database/roles/app_role \
    db_name=mysql-db \
    creation_statements="GRANT ALL ON appdb.* TO '{{name}}'@'%' IDENTIFIED BY '{{password}}'" \
    default_ttl="1h" \
    max_ttl="24h" > /dev/null

# set VAULT_ADDR for root and vagrant users
grep VAULT_ADDR ~/.bash_profile || {
  echo export VAULT_ADDR=http://127.0.0.1:8200 | sudo tee -a ~/.bash_profile
}

grep VAULT_ADDR /home/vagrant/.bash_profile || {
  echo export VAULT_ADDR=http://127.0.0.1:8200 | sudo tee -a /home/vagrant/.bash_profile
}

# set VAULT_TOKEN for root and vagrant users
echo "vault token:"
cat /root/.vault-token
echo -e "\nvault token is on /root/.vault-token"

grep VAULT_TOKEN ~/.bash_profile || {
  echo export VAULT_TOKEN=\`cat /root/.vault-token\` | sudo tee -a ~/.bash_profile
}

grep VAULT_TOKEN /home/vagrant/.bash_profile || {
  echo export VAULT_TOKEN=\`sudo cat /root/.vault-token\` | sudo tee -a /home/vagrant/.bash_profile
}
