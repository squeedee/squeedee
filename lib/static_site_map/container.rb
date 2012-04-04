module StaticSiteMap
  class Container < Page

    def default_child(child=nil)
      super(child)
      @default_child ||= self.first()
    end

  end
end
