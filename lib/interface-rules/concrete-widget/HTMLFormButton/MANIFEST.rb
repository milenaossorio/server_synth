{
  name: "HTMLFormButton",
  version:  "0.0.1",
  description: "HTML Form Button tag",  
  compatible_abstracts: [ "SimpleActivator" ],
  dependencies: [ ],
  parameters: [
    {name: "content", mandatory: false, data_type: "string" },
    {name: "type", mandatory: false, data_type: "string", default_value: "submit"},
		{name: "css_class", mandatory: false, data_type: "string"},
    {name: "id", mandatory: false, data_type: "string"},
		
  ],
  examples: [
    %q{maps_to abstract: "send", concrete_widget: "HTMLFormButton"}
  ]
}  
