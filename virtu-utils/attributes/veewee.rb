#
# Cookbook Name:: virtu-utils
# Attributes:: veewee
#
# Copyright 2013, Damien DUPORTAL
#
#

node.default['veewee']['dependencies'] = ["libgdbm-dev", "pkg-config", "libffi-dev"]
node.default['veewee']['gitUrl'] = "https://github.com/jedi4ever/veewee.git"
node.default['veewee']['installDir'] = "/usr/local/veewee"