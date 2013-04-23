#
# Cookbook Name:: serverinstall
# Attributes:: default
#
# Copyright 2013, Damien DUPORTAL
#
#

node.default['serverinstall']['packages'] = ["git","vim","curl","aptitude","ruby","rubygems","sysstat"]
node.default['serverinstall']['profiles'] = ["alias-profile.sh","color-profile.sh"]
node.set['virtualbox']['version'] = 4.2
node.set['vagrant']['version'] = "1.0.7"
node.set['vagrant']['versionUrl'] = "http://files.vagrantup.com/packages/1e2d92d0ed73e28346bb74345c8e353bcab415fb"
