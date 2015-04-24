class DHTMLXSchedulerLineHead < ConcreteWidget::WidgetBase
  def initialize(params)
    @content  = params[:content] || ""
    @name = params[:name]
    @id = params[:id]
		@css_class = params[:css_class]
    @params = params
		
  end
	def render
		text = super(params)
		@parent.add_entry('section', text) if @parent.respond_to?(:add_entry)
	end
end