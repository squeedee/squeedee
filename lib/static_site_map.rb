require 'static_site_map/node_base'
require 'static_site_map/anchor'
require 'static_site_map/page'
require 'static_site_map/container'
require 'static_site_map/core_ext'

# todos
# fixme use concern
# fixme make a gem
module StaticSiteMap
  Root = Page.new(:root)
end
