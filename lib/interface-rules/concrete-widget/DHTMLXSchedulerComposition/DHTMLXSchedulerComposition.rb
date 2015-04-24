class DHTMLXSchedulerComposition < ConcreteWidget::WidgetBase
  def initialize(params)
    @content  = params[:content] || ""
    @css_class = params[:css_class]
		@css_style = params[:css_style] || "width:100%; height:100%;"
		@skin = params[:skin] || "default"
    @name = params[:name]
    @id = params[:id]
    @params = params
    @depends_on_ids = params[:depends_on_ids]
		@entries = Array.new
  end
    
  def dependencies
    ["HTMLPage"]
  end

	def add_skin(obj)
		skins = Hash.new
		skins["default"] = { :css => [], :js => [] }
		skins["glossy"] = { :css => ["/concrete-widget/#{self.class.to_s}/codebase/dhtmlxscheduler_glossy.css"], :js => [] }
		skins["terrace"] = { :css => ["/concrete-widget/#{self.class.to_s}/codebase/dhtmlxscheduler_dhx_terrace.css"], :js => ["/concrete-widget/#{self.class.to_s}/codebase/ext/dhtmlxscheduler_dhx_terrace.js"] }
		obj.include_js(skins[@skin][:js])
		obj.include_css(skins[@skin][:css])
	end
	
  def depends_on_ids
    @depends_on_ids
  end
  
	def add_entry(value)
		@entries << value
	end
	
  def run_dependencies(obj)
		add_skin(obj)
		obj.include_js(["/_shared/js/jquery-1.7.2.min.js", "/_shared/js/jquery-ui-1.8.21.custom.min.js", "/concrete-widget/#{self.class.to_s}/codebase/dhtmlxscheduler.js", "/concrete-widget/#{self.class.to_s}/codebase/ext/dhtmlxscheduler_timeline.js"])
    obj.include_css(["/_shared/css/ui-lightness/jquery-ui-1.8.21.custom.css", "/concrete-widget/#{self.class.to_s}/codebase/dhtmlxscheduler.css"])
		
  end
   
end