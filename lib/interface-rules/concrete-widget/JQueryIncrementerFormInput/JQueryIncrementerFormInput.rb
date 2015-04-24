class JQueryIncrementerFormInput < ConcreteWidget::WidgetBase
    def initialize(params)
      @content  = params[:content] || ""
      @css_class = params[:css_class]
      @name = params[:name]
      @id = params[:id]
      @params = params
			@min_value = params[:min_value]
			@max_value = params[:max_value]
			unless @min_value.nil? or @max_value.nil? or @min_value <= @max_value
				@min_value = nil
				@max_value = nil
			end			
			@content =  @min_value unless @min_value.nil? or @content >= @min_value
			@content = @max_value unless @max_value.nil? or @content <= @max_value
			
      @depends_on_ids = params[:depends_on_ids]
    end
    
    def dependencies
      ["HTMLPage"]
    end
    
    def depends_on_ids
      @depends_on_ids
    end
    
    def run_dependencies(obj)
      obj.include_js(["/_shared/js/jquery-1.7.2.min.js", "/_shared/js/jquery-ui-1.8.21.custom.min.js"])
      obj.include_css(["#{self.relative_path}/css/style.css"])
    end
   
end