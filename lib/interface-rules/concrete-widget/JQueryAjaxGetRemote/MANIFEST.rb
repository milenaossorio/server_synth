{
  name: "JQueryAjaxGetRemote",
  version:  "0.0.1",
	source: "http://api.jquery.com/jQuery.ajax/",
  description: "Get remote data from ajax request and insert the result into an HTML interface element",  
  compatible_abstracts: [ "CompositeInterfaceElement" ],
  dependencies: [ "HTMLPage" ],
  parameters: [
    {name: "css_class", mandatory: false, data_type: "string"},
    {name: "id", mandatory: true, data_type: "string"},
    {name: "url", mandatory: true, data_type: "string"}
    
  ],
  examples: [
    %q{
		maps_to abstract: "result", concrete_widget: "JQueryAjaxGetRemote", 
        params: { url: "http://www.site/my_page", id: "result", 
              }
  }
  ]
}  

