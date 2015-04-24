class HTMLPage < ConcreteWidget::WidgetBase
    
  def initialize(params)
    @title  = params[:title] || "Page"
    @content  = params[:content] || ""
    self.include_js params[:include_js]
    self.include_css params[:include_css]
		@name = params[:name]
		@css_class = params[:css_class]
		@params  = params
		@id = params[:id]
		@extensions = []
		@insertion_position = params[:insertion_position] 
  end
  
  def include_js(plus)
    @include_js ||= []
		plus ||= []
		plus = plus.is_a?(String) ? [plus] : plus
		@include_js += plus
    @include_js.uniq!
  end
  
  def js_libs
    @include_js
  end
  
  def include_css(plus)
		@include_css ||= []
		plus ||= []
    plus = plus.is_a?(String) ? [plus] : plus
		@include_css += plus
		@include_css.reverse!
    @include_css.uniq!
  end
  
  def css_libs
    @include_css
  end
  
  def title
    @title
  end
  
end