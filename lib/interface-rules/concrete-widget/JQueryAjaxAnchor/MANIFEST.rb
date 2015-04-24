{
  name: "JQueryAjaxAchor",
  version:  "0.0.1",
  source: "http://api.jquery.com/jQuery.ajax",
  description: "HTML anchor that get remote data from ajax request and insert the result into an HTML interface element",  
  compatible_abstracts: [ "SimpleActivator" ],
  parameters: [
    {name: "css_class", mandatory: false, data_type: "string"},
    {name: "id", mandatory: false, data_type: "string"},
    {name: "url", mandatory: true, data_type: "string"},
	{name: "content", mandatory: true, data_type: "string"},
    {name: "result_element_id", mandatory: true, data_type: "string"},
    {name: "title", mandatory: false, data_type: "string"},
       
  ],
  examples: [
    %q{
	maps_to abstract: "link1", concrete_widget: "JQueryAjaxAchor", 
    params: { url: "http://localhost/context/my_id_123456", 
              result_element_id: "result_box", 
              content: "Click to see more" }
  }
  ]
}  

