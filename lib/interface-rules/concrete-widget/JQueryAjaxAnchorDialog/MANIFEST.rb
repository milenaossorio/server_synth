{
  name: "JQueryAjaxAnchorDialog",
  version:  "0.0.1",
	source: 'http://jqueryui.com/dialog'
  description: "Execute a ajax request and open the content into a Jquery dialog window",  
  compatible_abstracts: [ "PredefiniteVariable" ],
  dependencies: [ "HTMLPage" ],
  parameters: [
    {name: "css_class", mandatory: false, data_type: "string"},
    {name: "id", mandatory: false, data_type: "string"},
		{name: "content", mandatory: true, data_type: "string"},
		{name: "dialog_id", mandatory: true, data_type: "string"},
		{name: "height", mandatory: false, data_type: "number/string"},
		{name: "width", mandatory: false, data_type: "number/string"},
		{name: "url", mandatory: true, data_type: "string"},
    
  ],
  examples: [
    %q{
		maps_to	abstract: "info", concrete_widget: "JQueryAjaxAnchorDialog", 
		params: {content: "More info", url: "/more_info.html", dialog_id: "more_info", title: "More informations", width: 300 }
  }
  ]
}  
