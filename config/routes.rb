require 'static_site_map'

StaticSiteMap::Root.draw do
  uri "/"
  controller "client/about"

  page :about do
    default
    uri "/about"
    controller "client/about"
  end
end

Squeedee::Application.routes.draw do
  get "about/index"

  StaticSiteMap::Root.map_routes(self)

  # todo: sitemap needs to do this
  root to: "client/about#index"
end
