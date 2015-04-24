class SHDMNavigationAnchor < ConcreteWidget::WidgetBase
   def initialize(params)
		@separator = params[:separator] || " "
		@content  = params[:content] || ""
    @css_class = params[:css_class] || ""
    @name = params[:name]
    @options = params[:options]
    @id = params[:id]
    @params  = params
	 end
end