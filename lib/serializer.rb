module Serializer
  
  def serialize
    case self.class.to_s
      when 'IndexEntryDecorator'
        self.IndexEntryDecorator_serializer
      when 'SHDM::ContextIndex::ContextIndexInstance'
        self.ContextIndexInstance_serializer
      when 'SHDM::Context::ContextInstance'
        self.ContextInstance_serializer
      when 'NodeDecorator'
        self.NodeDecorator_serializer
      when 'SHDM::Resource'
        self.Resource_serializer
      else
        {}
    end
      
  end
  
  def parameters_to_url()
    if self.respond_to?(:parameters)
      parameters = self.parameters
      if parameters.is_a?(Hash) && !parameters.empty?
        parameters.merge!(parameters){|i,v| v.respond_to?(:uri) ? { "resource" => v.uri } : v }
        "?#{parameters.to_query}" 
      end
    end
  end
  
  protected
    ##############################
    #### Json format example #####
    ##############################
    
    # {"http://myIndexEntryResourceUrl" : {  "name" : [{"value" :"Paul Octopus", "url" : "http://context?node=http://paul }] }
    # -|------------------------------|----|--------|--|------------------------------------------------------------------|
    #         - Resource URI               - property            - hash with value and more details of the property
    
    def get_hash_node(node)
      if node.is_a?(IndexNodeAttribute)
       { :value => "#{CGI::escape(node.index.to_s)}#{node.parameters_to_url}", :type => node.class.to_s, :url => node.respond_to?(:target_url) ? node.target_url : nil, :parameters => node.parameters_to_url }
      elsif  node.is_a?(ContextAnchorNodeAttribute)
        { :value => node.label.to_s, :type => node.class.to_s, :target_url => node.target_url, :url => node.target_url(true) }
      elsif node.is_a?(RDF::Property)
        #node.map{|property| { :value => node.to_s, :type => node.class.to_s } }
        node.to_a.map{|property| { 
          :value => property.is_a?(RDFS::Resource) ? (property.rdfs::label.empty? ? property.compact_uri : property.rdfs::label.first) : property.to_s, 
          :type => property.class.to_s, :uri => property.is_a?(RDFS::Resource) ? property.compact_uri : nil } }
        
      else
        { :value => node.label.to_s, :type => node.class.to_s, :url => node.respond_to?(:url) ? node.url : nil }
      end
    end
    
    def IndexEntryDecorator_serializer
      uri = self.uri.to_s
      attributes_hash = self.attributes_hash
      hash_result = { uri => {} }
      self.attributes_names.each{|node| hash_result[uri][node] = [get_hash_node(attributes_hash[node])] }
      hash_result
    end
  
    def ContextIndexInstance_serializer
      { self.uri.to_s => {"shdm:index_title" => self.index_title, "shdm:index_name" => self.index_name, "shdm:index_nodes" => self.nodes.map{ |node| {:value => "#{node.to_s}#{node.parameters_to_url}", :type => node.class.to_s} }} }
    end
    
    def ContextInstance_serializer
      { self.uri.to_s => {"shdm:context_name" => self.context_name, "shdm:context_title" => self.context_title, "shdm:context_resources" => self.resources.map{ |node| {:value => "#{node.to_s}#{node.parameters_to_url}", :type => node.class.to_s} }} }
    end
    
    def NodeDecorator_serializer
      uri = self.uri.to_s
      
      hash_result = { uri => {
        "context" => [self.context.uri],
        "label" => self.rdfs::label || [self.compact_uri],
        "resource_properties" => [{}],
        "navigational_properties" => [{
          "node_position" => self.node_position,
          "next_node" => self.next_node_anchor.respond_to?(:target_url) ? self.next_node_anchor.target_url(true) : nil,
          "previous_node" => self.previous_node_anchor.respond_to?(:target_url) ? self.previous_node_anchor.target_url(true) : nil,
          "next_node_target_url" => self.next_node_anchor.respond_to?(:target_url) ? self.next_node_anchor.target_url : nil,
          "previous_node_target_url" => self.previous_node_anchor.respond_to?(:target_url) ? self.previous_node_anchor.target_url : nil
        }]
        }
      }
      # navigational_properties 
      attributes_hash = self.attributes_hash
      self.attributes_names.each{|node| hash_result[uri]["navigational_properties"].first[node] = [get_hash_node(attributes_hash[node])] }
      
      # resource_properties
      self.direct_properties.each{|property| hash_result[uri]["resource_properties"].first[property.label.to_a.empty? ? property.compact_uri : property.label.first] = get_hash_node(property) }
      hash_result
    end
    
    
    def Resource_serializer
      uri = self.uri.to_s
      hash_result = { uri => {
        "label" => self.rdfs::label || [self.compact_uri],
        "resource_properties" => [{}]
        }
      }
      # resource_properties
      self.direct_properties.each{|property| hash_result[uri]["resource_properties"].first[property.label.to_a.empty? ? property.compact_uri : property.label.first] = get_hash_node(property) }
      hash_result
    end
end