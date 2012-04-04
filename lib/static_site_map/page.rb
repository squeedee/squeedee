module StaticSiteMap
  class Page < NodeBase

    include Enumerable

    def initialize (id, parent = nil, opts={}, &block)
      @children_by_id = {}
      @opts = opts
      super(id, parent, &block)
    end

    def has_children?
      !@children_by_id.empty?
    end

    def [] (item)
      @children_by_id[item]
    end

    def << child
      @children_by_id[child.id] = child
    end

    def each
      if block_given?
        @children_by_id.each { |id, child| yield(child) }
      else
        enum_for(:each)
      end
    end

    def empty?
      @children_by_id.empty?
    end

    def container(id, opts={}, &block)
      self << Container.new(id, self, opts, &block)
    end

    def page (id, opts={}, &block)
      self << Page.new(id, self, opts, &block)
    end

    def anchor (id, label)
      self << Anchor.new(id, self, {label: label})
    end

    def map_routes (mapper)
      mapper.match({uri => route}.merge(@opts))
      @children_by_id.each { |id, node| node.map_routes(mapper) }
    end

    def find_by_uri(uri)
      return self if (uri == self.uri)
      match = nil
      @children_by_id.each do |id, child|
        match = child.find_by_uri(uri) if child.respond_to?(:find_by_uri)
        break unless match.nil?
      end

      return if match.nil?

      descend_defaults(match)

    end

    def draw &block
      block.arity == 1 ? yield(self) : instance_eval(&block)
    end

    def descend_defaults(page)
      until page.default_child.nil?
        page = page.default_child
      end
      page
    end


  end
end