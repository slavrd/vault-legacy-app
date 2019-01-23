# Vault with legacy application

A Vagrant project that demonstrates how to use Vault with an application which reads its configuration information from environment variables.

Upon start the Vagrant VM has a mysql database and vault installed as well as an application that uses a mysql database and reads its access credentials from environment variables.

Vault is configured with a database secret engine so that it can generate ephemeral credentials for access to mysql.

We use a tool - `envconsul` to launch the application. What it does is read secrets from Vault and then launch an application in a sub process where the secrets are set in environment variables. This way applications that get their configuration from environment variables can be used with Vault with minimum to no code changes.

## Prerequisites

* Install VirtualBox - [instructions](https://www.virtualbox.org/wiki/Downloads)
* Install Vagrant - [instructions](https://www.vagrantup.com/downloads.html)

## Running the project

* Start the Vagrant VM - `vagrant up`
* Login to the VM - `vagrant ssh`
* Launch the application with `envconsul` - `/vagrant/app_launcher.sh`

The application itself - `/vagrant/app.sh` - is not aware of Vault. It reads its database access credentials form environment variables.

Every time that the application is launched it will be provided with a different set of credentials.

This demonstrates how Vault can solve the problems presented by static credentials set in configuration files. They have a much higher chance to be leaked and are usually difficult and slow to be replaced.

Instead we have every application instance use different set of temporary credentials every time it is launched. This provides multiple advantages:

* Even if credentials are leaked they will expire
* Disabling a set of credentials will affect a single application instance as opposed to all instances of multiple applications
* Every action taken on the database can be traced to a specific application instance based on the credentials used to perform it
