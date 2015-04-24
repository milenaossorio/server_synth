class HTMLHeading < ConcreteWidget::WidgetBase
  def initialize(params)
		@number  = params[:number] || params[:size] || "1"
    @content  = params[:content] || ""
    @css_class = params[:css_class] || ""
    @name = params[:name]
    @params  = params
    @id = params[:id]
  end
  
  def number
      @number
  end
  
  
end