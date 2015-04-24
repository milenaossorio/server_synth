{
  name: "JQueryIncrementerFormInput",
  version:  "0.0.1",
  description: "Form input number incrementer. There are buttons to increase (plus) and decrease (minus) integer values from zero.",  
  compatible_abstracts: [ "PredefiniteVariable" ],
  dependencies: [ "HTMLPage" ],
  parameters: [
    {name: "css_class", mandatory: false, data_type: "string"},
    {name: "id", mandatory: false, data_type: "string"},
		{name: "content", mandatory: false, data_type: "string"},
		{name: "min_value", mandatory: false, data_type: "number"},
		{name: "max_value", mandatory: false, data_type: "number"}
    
  ],
  examples: [
    %q{
		maps_to abstract: "age", concrete_widget: "JQueryIncrementerFormInput"
		
		maps_to abstract: "passengers", concrete_widget: "JQueryIncrementerFormInput", 
    params: { min_value: 1, max_value: 10, content: 1 }
  }
  ]
}  

