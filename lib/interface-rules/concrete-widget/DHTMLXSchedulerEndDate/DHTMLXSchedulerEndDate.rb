class DHTMLXSchedulerEndDate < ConcreteWidget::WidgetBase
  def initialize(params)
    @content  = params[:content] || ""
    @name = params[:name]
    @id = params[:id]
    @params = params
  end
	
	def render
		@parent.add_entry('end_date', content)
	end	
end