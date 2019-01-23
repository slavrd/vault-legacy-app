#!/usr/bin/env bash
# Launch the application with environment variables populated form vault

envconsul -vault-renew-token=false -upcase -secret database/creds/app_role /vagrant/app.sh