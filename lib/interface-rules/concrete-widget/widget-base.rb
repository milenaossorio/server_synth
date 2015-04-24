# ConcreteWidget.rb -- Class required for all concrete widgets
# Author:: Vagner Nascimento (vagnernascimento@gmail.com)

module ConcreteWidget
  class WidgetBase
    CURRENT_PATH = "#{RAILS_ROOT}/lib/interface-rules/concrete-widget"
    #VERSION "0.1.1"
    
    def initialize(params)
      @content  = params[:content] || ""
      @css_class = params[:css_class] 
      @name = params[:name]
      @params  = params
      @id = params[:id]
      @extensions = []
			@insertion_position = params[:insertion_position] 
    end
    
    def add_content(new_content, on_bottom = true)
      if on_bottom
          @content = @content + new_content.to_s
      else
          @content = new_content.to_s + @content
      end
    end
    
    def <<(new_content)
      add_content(new_content)
    end
    
    def content=(new_content)
      @content = new_content.to_s
    end 
    
    def content
      @content || ""
    end  
    
    def name
      @name
    end
    
    def name=(name)
      @name = name
    end
    
    def params
      @params
    end
    
    def params=(params)
      @params = params
    end
    
    def id
      @id
    end
    
    def id=(id)
      @id = id
    end
    
    def css_class
      @css_class
    end
    
    def css_class=(css)
      @css_class = css
    end
    
    def parent=(parent)
      @parent = parent
    end
    
    def parent
      @parent
    end
    def target=(node)
      @target = node
    end
    
    def target
      @target
    end
    
    def extensions
      @extensions
    end
    
    def extensions=(ext)
      @extensions ||= []
      @extensions << ext
    end
    
    def add_extension(ext)
      @extensions ||= []
      @extensions << ext
    end
    
		def insertion_position
			@insertion_position || @params[:insertion_position] || "after"
		end
		
    def relative_path
      type = self.is_a?(ConcreteWidget::Extension) ? "extensions" : "concrete-widget"
      "/#{type}/#{self.class}/"
    end
    
    def render_extensions(source_rendered = "")
			extensions.each{ |ext| 
        ext.parent = self
				if ext.insertion_position == 'around'
					ext.content << source_rendered
					puts ext.content
					source_rendered =  ext.render
				elsif ext.insertion_position == 'before'
					source_rendered = ext.render << source_rendered
				else
					source_rendered = source_rendered << ext.render
				end
      } unless extensions.nil?
			
			return source_rendered
    end
    
    def render(params={})
      require "tilt"
      path_mask = "#{CURRENT_PATH}/#{self.class.to_s}/template.*"
      template_list = Dir.glob(path_mask)
      unless template_list.empty?
        template = Tilt.new(template_list.first)
				render_extensions(template.render(self, params ))
      else
        self.content << render_extensions
      end
    end
    
    def widget_instance(name, params)
      #load "concrete-widget/#{name}/#{name}.rb"
      require "concrete-widget/#{name}/#{name}"
      klass = eval(name)
      klass.new(params) unless klass.nil?
    end
    
  end
  
  class Extension < WidgetBase
    
    def render(params={})
      require "tilt"
      require "markaby"
      #path_mask = "#{File.dirname(__FILE__)}/../extensions/#{self.class.to_s}/template.*"
			path_mask = "#{CURRENT_PATH}/../extensions/#{self.class.to_s}/template.*"
      template_list = Dir.glob(path_mask)
      unless template_list.empty?
        template = Tilt.new(template_list.first)
        template.render(self, params )
      else
        self.content
      end
    end
    
  end
end