# Maven recipe
# This chef recipe will install Maven and configure PATH ENV system wide

include_recipe "ark"
include_recipe "dd-jdk"

if (node['maven']['url'].nil? or node['maven']['url'].empty?)
  node.set['maven']['url'] =  "http://apache.mirrors.pair.com/maven/maven-3/#{node['maven']['version']}/binaries/apache-maven-#{node['maven']['version']}-bin.tar.gz"
end

log "[Maven] we'll download maven version #{node['maven']['version']} from #{node['maven']['url']}"

if (node['maven']['m2_home'].nil? or node['maven']['m2_home'].empty?)
  node.set['maven']['m2_home'] =  "/usr/local/maven"
end

log "[Maven] m2 home is #{node['maven']['m2_home']}"

# Download and install maven
ark "maven" do
  url node['maven']['url']
  home_dir node['maven']["m2_home"]
  version node['maven']['version']
  append_env_path true
  action :install
end
