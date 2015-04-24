{
  name: "HTMLComposition",
  version:  "0.0.1",
  description: "HTML Div tag",  
  compatible_abstracts: [ "CompositeInterfaceElement" ],
  dependencies: [ ],
  parameters: [
    {name: "content", mandatory: false, data_type: "string" },
    {name: "css_class", mandatory: false, data_type: "string"},
    {name: "id", mandatory: false, data_type: "string"},
  ],
  examples: [
    %q{
		maps_to abstract: "link1", concrete_widget: "HTMLComposition", params: {  content: 'Some content' }}
  ]
}  
