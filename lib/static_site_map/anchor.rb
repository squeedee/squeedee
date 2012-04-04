module StaticSiteMap
  class Anchor < NodeBase

    def initialize(id, parent, opts={})
      @label = opts.delete(:label)
      super(id, parent)
    end

    def map_routes (mapper)
    end

  end
end
