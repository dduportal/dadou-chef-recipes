#
# Cookbook Name:: jdk
# Attributes:: default
#
# Copyright 2013 Damien DUPORTAL <damien.duportal@gmail.com>
#

node.default['jdk']['majorversion'] = 7 # Last minor version will be used? OpenJDK is used by default
#node.default['jdk']['packagename'] = "" # Customize rpm packagename to install if you don't want most recent AW one
#node.default['jdk']['home'] = "" # Customize java home
