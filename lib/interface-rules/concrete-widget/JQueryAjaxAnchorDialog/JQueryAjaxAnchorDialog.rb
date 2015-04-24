class JQueryAjaxAnchorDialog < ConcreteWidget::WidgetBase
    def initialize(params)
			@content  = params[:content] || ""
			@name = params[:name]
			@css_class = params[:css_class]
			@url = params[:url] || ""
			@title = params[:title] || @content
			@id = params[:id]
			@dialog_id = params[:dialog_id] || params[:id]
			@params = params
			@height = params[:height] || 'auto'
			@width = params[:width] || 'auto'
      @depends_on_ids = params[:depends_on_ids]
    end
    
    def dependencies
      ["HTMLPage"]
    end
    
    def depends_on_ids
      @depends_on_ids
    end
    
    def run_dependencies(obj)
      obj.include_js(["/_shared/js/jquery-1.7.2.min.js", "/_shared/js/jquery-ui-1.8.21.custom.min.js", "#{self.relative_path}/js/open_dialog.js"])
      obj.include_css(["/_shared/css/ui-lightness/jquery-ui-1.8.21.custom.css"])
    end
   
end