class JQueryAnythingSlider < ConcreteWidget::WidgetBase
  def initialize(params)
    @content  = params[:content] || ""
    @css_class = params[:css_class]
    @name = params[:name]
    @id = params[:id]
		
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
    obj.include_js(["/_shared/js/jquery-1.7.2.min.js", "#{self.relative_path}js/jquery.anythingslider.js"])
    obj.include_css(["#{self.relative_path}css/anythingslider.css"])
  end
   
end