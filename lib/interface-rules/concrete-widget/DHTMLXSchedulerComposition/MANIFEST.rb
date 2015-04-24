{
  name: "DHTMLXSchedulerComposition",
  version:  "0.0.1",
	source: "http://dhtmlx.com/docs/products/dhtmlxScheduler/",
  description: "DhtmlxScheduler is a web-based JavaScript event calendar ",  
  compatible_abstracts: [ "ElementExhibitor" ],
  dependencies: [ "HTMLPage" ],
  parameters: [
    {name: "css_class", mandatory: false, data_type: "string"},
    {name: "id", mandatory: false, data_type: "string"},
    {name: "css_style", mandatory: false, data_type: "string", default_value: "width:100%;height:100%;"},
		{name: "skin", mandatory: false, data_type: "string", default_value: "default", options: "glossy, terrace"},
  ],
  examples: [
    %q{
maps_to	abstract: "flights", concrete_widget: "DHTMLXSchedulerComposition", params: {css_class: "timeline_grid", collection: index.entries, as: :flight}
	maps_to	abstract: "flight", concrete_widget: "DHTMLXSchedulerEntry"
	maps_to	abstract: "flight_price", concrete_widget: "DHTMLXSchedulerLineHead", params: {content: flight.price.label.to_s}
	maps_to	abstract: "flight_name", concrete_widget: "DHTMLXSchedulerText", params: {content: flight.io::flight.to_s}
	maps_to	abstract: "flight_depart", concrete_widget: "DHTMLXSchedulerStartDate", params: {content: flight.start_date.label.to_s}
	maps_to	abstract: "flight_arrive", concrete_widget: "DHTMLXSchedulerEndDate", params: {content: flight.end_date.label.to_s}
  }
  ]
}  

