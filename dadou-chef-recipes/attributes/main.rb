#
# Cookbook Name:: dadou-chef-recipes
# Attributes:: main
#
# Copyright 2012 Damien DUPORTAL <damien.duportal@gmail.com>
# https://github.com/dduportal/dadou-chef-recipes
#


# Main Attributes
set[:dadou][:yum][:custom_repo] = ['epel.repo']
set[:dadou][:yum][:packages] = ['dash','MAKEDEV','dracut-kernel','tar','zip','mlocate','vim','wget','libxml2','vim-enhanced','bind-utils','sysstat','screen']

