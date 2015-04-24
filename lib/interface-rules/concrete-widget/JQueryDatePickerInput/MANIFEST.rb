{
  name: "JQueryDatePickerInput",
  version:  "0.0.3",
	source: "http://jqueryui.com/datepicker",
  description: "Form input with Jquery Date Picker Calendar",  
  compatible_abstracts: [ "IndefiniteVariable" ],
  dependencies: [ "HTMLPage" ],
  parameters: [
    {name: "css_class", mandatory: false, data_type: "string"},
    {name: "id", mandatory: false, data_type: "string"},
		{name: "content", mandatory: false, data_type: "string"},
    {name: "date_format", mandatory: false, data_type: "string", default_value: "yy-mm-dd"},
		{name: "min_date", mandatory: false, data_type: "number,string"},
		{name: "max_date", mandatory: false, data_type: "number,string"}
    
  ],
  examples: [
    %q{
		maps_to abstract: "date1", concrete_widget: "JQueryDatePickerInput", 
    params: { date_format: "yy-mm-dd", 
		          min_date: -1 } # Dates from yesterday
		
		maps_to abstract: "date2", concrete_widget: "JQueryDatePickerInput", 
    params: { date_format: "yy-mm-dd", 
		          min_date: "+1m +7d" } # Enabling dates 1 month and 7 days from today
  }
  ]
}  

