{
  name: "DHTMLXSchedulerEntry",
  version:  "0.0.1",
  description: "DHTMLX Scheduler Entry",  
  compatible_abstracts: [ "SimpleActivator" ],
  dependencies: [ ],
  parameters: [
    {name: "content", mandatory: true, data_type: "string" },
    {name: "url", mandatory: true, data_type: "string"},
    {name: "css_class", mandatory: false, data_type: "string"},
    {name: "id", mandatory: false, data_type: "string"},
  ],
  examples: [
    %q{
		maps_to abstract: "link1", concrete_widget: "HTMLAnchor",
		params: {  content: 'My link anchor', url: '/mypage.html' }

		maps_to abstract: "link2", concrete_widget: "HTMLAnchor",
		params: {  content: variable.label, url: variable.url } do
			equal variable.label, "Home"
		end}
  ]
}  
