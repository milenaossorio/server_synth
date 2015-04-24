{
  name: "HTMLForm",
  version:  "0.0.1",
  description: "HTML Form tag",  
  compatible_abstracts: [ "SimpleActivator" ],
  dependencies: [ ],
  parameters: [
    {name: "content", mandatory: false, data_type: "string" },
    {name: "action", mandatory: false, data_type: "string"},
    {name: "method", mandatory: false, data_type: "string", default_value: "post"},
		{name: "css_class", mandatory: false, data_type: "string"},
    {name: "id", mandatory: false, data_type: "string"},
		
  ],
  examples: [
    %q{maps_to abstract: "link1", concrete_widget: "HTMLForm"
		
		maps_to abstract: "link1", concrete_widget: "HTMLForm",
		params: {action: "/execute/operation1", method: "get"} }
  ]
}  
