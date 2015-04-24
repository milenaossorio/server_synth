class JQueryCopyDateTo < ConcreteWidget::Extension
   def initialize(params)
      @name = params[:name]
      @id = params[:id]
      @params = params
      @parent = params[:parent]
			@add_days = params[:add_days] || 0
			@string_format = params[:string_format] || ""
      @depends_on_ids = params[:depends_on_ids]
    end
    
    def dependencies
      ["HTMLPage"]
    end
    
    def depends_on_ids
      @depends_on_ids
    end
    
    def run_dependencies(obj)
      obj.include_js(["/_shared/js/jquery-1.7.2.min.js"])
			obj.include_js(["#{self.relative_path}js/date.js"])
    end
end