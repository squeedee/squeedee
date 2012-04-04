module StaticSiteMap
  module CoreExt

    def has_static_pages
      helper_method :current_page
      helper_method :page_active?
      helper_method :get_page
      helper_method :uri_for_page
      helper_method :root_page

      send :include, InstanceMethods
    end

    module InstanceMethods

      # @param page [Object] a page (node from the breadcrumbs), a path: [:welcome/:to_the_restaurant], or a URI: /welcome/restaurant
      def page_active?(page)
        current_page.breadcrumbs.include?(get_page(page))
      end

      # @param page [Object] a page (node from the breadcrumbs), a path: [:welcome/:to_the_restaurant], or a URI: /welcome/restaurant
      def get_page(page)
        return page if page.is_a?(StaticSiteMap::Page)
        return uri_as_page(page) if page.is_a?(String)
        page = [page] unless page.is_a? Array
        path_as_page(page)
      end

      def current_page
        uri_as_page(request.env['PATH_INFO'])
      end

      def uri_for_page(*path)
        path_as_page(path).uri
      end

      private

      def uri_as_page(uri)
        root_page.find_by_uri(uri)
      end

      def root_page
        StaticSiteMap::Root
      end

      def path_as_page(path)
        remaining_path = path.reverse
        page = root_page
        until remaining_path.empty?
          page = page[remaining_path.pop.to_sym]
          throw "Path does not exist: #{path.join " "}" if page.nil?
        end
        page
      end

    end
  end

end

ActionController::Base.send(:extend, StaticSiteMap::CoreExt)