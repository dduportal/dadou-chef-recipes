name             'serverinstall'
maintainer       'Damien Duportal'
maintainer_email 'damien.duportal@gmail.com'
description      'Install my custom debian server with VM managed by vagrant/VBox as a service'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "build-essential" # opscode
depends "apt" # opscode
depends "vagrant" # opscode
depends "dd-nginx"
