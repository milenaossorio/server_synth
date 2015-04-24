class JQueryAjaxAnchor < ConcreteWidget::WidgetBase
  def initialize(params)
    @content  = params[:content] || ""
    @css_class = params[:css_class]
    @name = params[:name]
    @id = params[:id]
	@url = params[:url]
	@title = params[:title]
    @result_element_id = params[:result_element_id]
    @depends_on_ids = params[:depends_on_ids]
  end
    
end