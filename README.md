# Dadou custom chef recipes

Here you can find my chef recipes for working with Centos and Virtual Box anywhere.

# What's inside ?

Inside this repository representing my chef cookbooks, you can find one folder per cookbook.
 * Some cookbooks are other's, you can locate them with their green color. They contains a ".git" subdirectory pointint to the owner's repository. Yum is an example, fetched from [Official Opscode yum cookbook]
 * My custom cookbooks you can reuse, modify, contribute as you want.

# Requirements :

 * [VirtualBox] >= 4.2
 * [Vagrant] >= 1.0.5
 * [VeeWee] >= 0.3.1
 * My setup (so haven't tested others configurations yet) :
  > My working VM is a centos 6.3 minimal build built from veewee (my veewee templates are here : https://github.com/dduportal/dadou-veewee-templates)
  > I'm working on Mac OS X 10.8.2 Host

# How to begin ?

Just point out the cookbook folder from your VagrantFile :

````ruby
  chef.cookbooks_path = ['/path/to/your/cookbook','/path/to/this/fetched/git/repo/cookbook']
````

or use tarball version within your Vagrantfile in order to direct download cookbook fixed version :

````ruby
  chef.recipe_url = "https://github.com/dduportal/dadou-chef-recipes/archive/<YOUR VERSION>.tar.gz"
````

and there you go :

````ruby
  chef.add_recipe("somecookbook::somerecipe")
````

# Todo

Some things i'm working on :
 * Improving documentation : one readme per cookbook
 * Stabilizing existing cookbooks : implementing missing actiosn for LWRP into nginx
 * Industrialize testings : actually, this is handwork for my needs. I should cucumuber or kitchen tests with Travis.
 * Adding example folder with Vagrantfile

# Roadmap :

- v0.3 (not initialized yet) :
  * Adding php-fpm cookbook with docs and all actions
  * Adding a utils cookbook for proxy, and my basics packages, aliases, etc.

- v0.2.1 (https://github.com/dduportal/dadou-chef-recipes/tree/develop) :
  * Adding some documentation :
    > global
    > postgresql cookbook
    > nginx cookbook
  * Corrections onto nginx cookbook (writing missing LRWP implementations)
  * Adding example directory

# Changelog

- v0.2 (https://github.com/dduportal/dadou-chef-recipes/tree/0.2) :
 * Adding postgresql cookbook with recipes for :
   > client
   > server (default 8.4, tested with 9.1 and 9.2.2)
   > postgis (default 2.0.x)

- v0.1 (not tagged) :
 * Adding opscode yum cookbook
 * Adding my beginner's cookbook for nginx
 * Adding sandbox-cookbook for playing around

[VeeWee]: https://github.com/jedi4ever/veewee
[Vagrant]: http://vagrantup.com
[VirtualBox]: http://virtualbox.org
[Chef Solo]: http://wiki.opscode.com/display/chef/Chef+Solo
[Puppet]: http://puppetlabs.com
[Official Opscode yum cookbook]: https://github.com/opscode-cookbooks/yum
