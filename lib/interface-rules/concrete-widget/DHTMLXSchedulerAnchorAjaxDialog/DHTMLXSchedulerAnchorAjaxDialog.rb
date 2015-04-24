class DHTMLXSchedulerAnchorAjaxDialog < ConcreteWidget::WidgetBase
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
  end
	
	def render(params={})
		text = super(params)
		parent.add_entry('text', text)
	end
end