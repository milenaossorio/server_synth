class RestController < ApplicationController
  
  def index
    #cleaning extra parameters
    params.delete(:controller)
    params.delete(:action)

    index_id = params.delete(:id)
      unless index_id.nil?
      index = SHDM::Index.find(index_id) unless index_id.nil?
      index = index.nil? ? SHDM::Index.find_all.first : index

      new_params = {}
      params.each{ |i,v| new_params[i] = v.is_a?(Hash) ? RDFS::Resource.new(v["resource"]) : v }
      new_params.delete('authenticity_token')

      index = index.new(new_params)
      result = ( params[:node].nil? ? index : index.entry(RDFS::Resource.new(params[:node])) ).serialize
    else
      result = {}
    end
    respond_to do |format|
      format.json  { render :json => result }
      format.text { render :text => result.inspect }
      #format.xml  { render :xml => result }
    end
  end
 
 
  def context
    params.delete(:controller)
    params.delete(:action)

    context_id = params.delete(:id)
    
    unless context_id.nil?
      node_id    = params.delete(:node)
      context    =  SHDM::Context.find(context_id)

      new_params = {}
      params.each{ |i,v| new_params[i] = v.is_a?(Hash) ? RDFS::Resource.new(v["resource"]) : v }
      new_params.delete('authenticity_token')

      context   = context.new(new_params)
      result = ( node_id.nil? ? context : context.node(RDFS::Resource.new(node_id)) ).serialize
    else
      result = {}
    end
    respond_to do |format|
      format.json  { render :json => result }
      format.text { render :text => result.inspect }
      #format.xml  { render :xml => result }
    end
  end
  
  def resource
    resource_id = params.delete(:id)
    resource    = resource_id.nil? ? {} : SHDM::Resource.new(resource_id) 
    respond_to do |format|
      format.json  { render :json => resource.serialize }
      format.text { render :text => resource.inspect }
      #format.xml  { render :xml => result }
    end
  end
end

# key params: ontology, mainClass, paths, option, options, index_id
  def create_index_anchor_wizard(params)
    print "LOG: begin: create_index_anchor_wizard \n" if @log_name or true
    print "LOG: params: #{params} \n" if @log_param or true

    path = params['paths'].select{|x| x['key'] = params['option']}.first["pathItems"]
    properties_path = '';
    index = 0;
    path.each{|item|
      properties_path = "#{properties_path}#{params['ontology']}::#{item['propertiesNames'][params['options'][index]]}."
      index += 1
    }

    index_key = "#{path.first['className']}_for_#{params['mainclass']}_IndexAnchor"
    index_position = @global_var[index_key][0] || 1
    name = "#{index_key}_#{index_position}"

    function_params = {'name' => name, 'title' => name,
      'query' => "#{params['ontology'].upcase}::#{path.first['className']}.find_all.select{ |x| context_param.#{properties_path}include? x}"}
    values = create_context_wizard(function_params)[:result]
    
    function_params = {'name' => 'context_param', 'context_id' => values['context']}
    create_parameter_for_context_wizard(function_params)

    function_params = {'name' => path.first['className'], 'index_id' => params['index_id'],
       'index_navigation_attribute_index' => values['defaultIndex']}
    create_index_attribute_for_index_wizard(function_params)
    
    val = get_context_attr_wizard({:id => values['defaultIndex']})[:result]
    function_params = {'index_id' => val['rows'][0]['id'], 'name' => 'context_param', 'expression' => 'parameters[:context_param]'}
    create_attribute_context_parameters_wizard(function_params)

    @global_var[index_key][0] = index_position + 1

    return {:status => true, :result => {}}

  end
