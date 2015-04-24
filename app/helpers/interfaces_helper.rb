module InterfacesHelper
	
	def concrete_widget_list
		folder_list("concrete-widget")
	end
	
	def extensions_list
		folder_list("extensions")
	end
	
	def options_with_widgets
		options_str = "<option value='' class='highlight'>Concrete Widgets</option>\n"
		options = Array.new
		concrete_widget_list.each do | widget |
			options << [ widget, "concrete-widget/#{widget}" ]
		end
		options_str << options_for_select(options)
		
		options = Array.new
		options_str << "<option value='' class='highlight'>Extensions</option>\n"
		extensions_list.each do | widget |
			options << [ widget, "extensions/#{widget}" ]
		end
		options_str << options_for_select(options)
		return options_str
	end
	
	def widget_manifest_hash(widget_name)
		path = file_path("#{widget_name}/MANIFEST.rb")
		if File.file?(path)
			return eval(File.new(path).read)
		end
	end
	
	private
	
	def file_path(extra_path)
		File.join(RAILS_ROOT, 'lib', 'interface-rules',  extra_path)
	end
	
	def folder_list(folder_name)
		folder_path = file_path(folder_name)
		folders = Array.new
		Dir.entries(folder_path).select { |file| 
			if File.directory?(File.join(folder_path, file)) and not file.match(/^[.]|[..]$/)
				folders << file
			end
		}
		return folders
	end
	
end
