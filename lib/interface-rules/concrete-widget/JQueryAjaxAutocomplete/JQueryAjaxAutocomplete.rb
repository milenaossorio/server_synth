class JQueryAjaxAutocomplete < ConcreteWidget::WidgetBase
  def initialize(params)
    @content  = params[:content] || ""
    @css_class = params[:css_class]
    @name = params[:name]
    @id = params[:id]
    @json_source_url = params[:json_source_url]
    @params_from_elements = params[:params_from_elements] || []
		@data_type = params[:data_type] || "json"
    @search_parameter = params[:search_parameter] || "search"
    @node_json_result_element = params[:node_json_result_element] || ""
    @hash_result_format = params[:hash_result_format] || "item"
		
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
    obj.include_js(["/_shared/js/jquery-1.7.2.min.js", "/_shared/js/jquery-ui-1.8.21.custom.min.js"])
    obj.include_css(["/_shared/css/ui-lightness/jquery-ui-1.8.21.custom.css"])
  end
   
end