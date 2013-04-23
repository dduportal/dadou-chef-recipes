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
