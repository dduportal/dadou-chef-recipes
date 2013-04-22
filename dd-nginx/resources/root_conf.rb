#
# Create /srv/:client_id/:server_id

actions :configure

default_action :configure

attribute :root_conf, :kind_of => [Hash, NilClass], :default => {}
attribute :service_id, :kind_of => String, :name_attribute => true
attribute :client_id, :kind_of => String, :required => true
attribute :prefix_folder, :kind_of => String, :default => "/WEBS"
attribute :cookbook, :kind_of => String, :default => 'nginx' # Use this to overwrite cookbook's templates provider
