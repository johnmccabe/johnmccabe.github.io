---
title: Cockpit for Raspberry Pi Management
excerpt: I recently hit 7 always-on Raspberry Pis and wanted a simple way of carrying out basic monitoring and management.
categories:
  - Technology
  - Projects
tags:
  - cockpit
  - raspbian
  - project
  - ubuntu
image:
  path: /assets/cockpit-on-raspberry-pi/dobby_snap_openfaas.gif
  thumbnail: /assets/openfaas-on-microk8s/dobby_snap_openfaas.gif
---


root@red:/home/pi# gpg --keyserver pgp.mit.edu --recv-keys 7638D0442B90D010 04EE7237B7D453EC
gpg: key E0B11894F66AEC98: 12 signatures not checked due to missing keys
gpg: /root/.gnupg/trustdb.gpg: trustdb created
gpg: key E0B11894F66AEC98: public key "Debian Archive Automatic Signing Key (9/stretch) <ftpmaster@debian.org>" imported
gpg: key 7638D0442B90D010: 13 signatures not checked due to missing keys
gpg: key 7638D0442B90D010: public key "Debian Archive Automatic Signing Key (8/jessie) <ftpmaster@debian.org>" imported
gpg: no ultimately trusted keys found
gpg: Total number processed: 2 
gpg:               imported: 2

gpg --armor --export 7638D0442B90D010 | apt-key add -
gpg --armor --export E0B11894F66AEC98 | apt-key add -

sudo apt install -y dirmngr

apt update

apt install cockpit