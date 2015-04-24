class JQueryAjaxGetRemote < ConcreteWidget::WidgetBase
    def initialize(params)
      @content  = params[:content] || ""
      @css_class = params[:css_class]
      @name = params[:name]
      @id = params[:id]
			@url =params[:url]
      @params = params
      @depends_on_ids = params[:depends_on_ids]
    end
    
    def dependencies
      ["HTMLPage"]
    end
    
    def depends_on_ids
      @depends_on_ids
    end
    
    def run_dependencies(obj)
      obj.include_js(["/_shared/js/jquery-1.7.2.min.js"])
    end
   
end