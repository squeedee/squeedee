require 'active_support/core_ext/string/inflections'

module StaticSiteMap
  class NodeBase

    attr_reader :parent, :id, :meta, :flags
    attr_writer :uri, :label, :controller, :action

    def initialize (id, parent = nil, &block)
      @id     = id
      @parent = parent
      @meta   = {}
      @flags  = {}

      if block_given?
        block.arity == 1 ? yield(self) : self.instance_eval(&block)
      end
    end

    def is_root?
      @parent.nil?
    end

    def controller(controller=nil)
      self.controller = controller unless controller.nil?
      @controller ||= default_controller
    end

    def action(action=nil)
      self.action = action unless action.nil?
      @action ||= default_action
    end

    def route= (route)
      @controller, @action = route.split("#")
    end

    def route(route=nil)
      self.route = route unless route.nil?
      "#{controller}##{action.to_s}"
    end

    def uri(uri=nil)
      @uri = uri.gsub(/^\//, "") unless uri.nil?
      @uri ||= default_uri
      @uri.gsub(/^\/*/, "/")
    end

    def label(label=nil)
      self.label = label unless label.nil?
      @label ||= default_label()
    end

    def breadcrumbs
      @breadcrumbs ||= generate_crumbs
    end

    def meta(symbol=nil, value=nil)
      @meta[symbol] = value unless symbol.nil?
      @meta
    end

    def flag(symbol=nil)
      @flags[symbol] = true unless symbol.nil?
      @flags
    end

    def flagged?(symbol)
      flags[symbol]
    end

    def unflag(symbol)
      @flags[symbol] = false
    end


    def default_uri
      "#{parent.uri}/#{id.to_s}"
    end

    def default
      throw "root cannot be default" if parent.nil?
      parent.default_child(self)
    end

    def default_child(child = nil)
      @default_child ||= child unless child.nil?
      @default_child
    end

    protected

    def generate_crumbs
      crumb = [self]
      until (next_crumb = crumb.first.parent).nil?
        crumb.unshift next_crumb
      end
      crumb
    end

    def default_label
      id.to_s.titlecase
    end

    def default_controller
      "#{parent.controller}/#{id.to_s}"
    end

    def default_action
      :index
    end

  end
end