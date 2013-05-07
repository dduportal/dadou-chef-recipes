#
# Cookbook Name:: serverinstall
# Attributes:: default
#
# Copyright 2013, Damien DUPORTAL
#
#

node.default['serverinstall']['packages'] = ["git","vim","curl","aptitude","ruby","rubygems","sysstat"]
node.default['serverinstall']['profiles'] = ["alias-profile.sh","color-profile.sh"]
node.default['serverinstall']['system_users'] = ["www"]
node.default['serverinstall']['users'] = ["dadou","juju","matt"]
node.set['virtualbox']['version'] = 4.2
node.set['vagrant']['version'] = "1.2.2"
node.set['vagrant']['url'] = "http://files.vagrantup.com/packages/7e400d00a3c5a0fdf2809c8b5001a035415a607b/vagrant_1.2.2_x86_64.deb"
node.set['vagrant']['checksum'] = "061ea2fcc5a25c037acd07bf606b0ed0"
node.set['vagrant']['plugins'] = ["vagrant-vbguest"]
node.set['nginx']['version'] = "1.2.8"
node.default['firewall']['rules'] = [
	{
		'ssh' => {
			'port' => '22',
			'action' => 'allow',
		},
	}
]
