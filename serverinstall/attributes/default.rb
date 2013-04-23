#
# Cookbook Name:: serverinstall
# Attributes:: default
#
# Copyright 2013, Damien DUPORTAL
#
#

node['serverinstall']['packages'] = ["git","vim","curl","aptitude","ruby","rubygems","sysstat"]
node['serverinstall']['profiles'] = ["alias-profile.sh","color-profile.sh"]
