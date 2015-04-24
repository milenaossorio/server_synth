require "rubygems"
module InterfaceRules
  
  class InterfaceRules::ConcreteInterface
		 
		 include ExtendDSLRules
    def initialize(hash)
			@hash = hash
			@cloned_nodes_by_source = Hash.new
			@extention_list = Array.new
			@direct_node_ref = Hash.new

		end
		
		def cloned
			@cloned_nodes_by_source
		end
		
		def hash
			@hash
		end

		
		def evaluate_node(element_name, node_values = nil)
			
			@interface_data
      rules_by_element = @rules_by_element
			counter = 0
			
			engine = Wongi::Engine.create
			#== Add facts
			@facts.each{| fact | engine << fact }
			#== interface data
			#hash_data = { :locals => node_values, :instance_variables => @interface_data}
      hash_data = { :locals => node_values, :instance_variables => {} }
      hash_data[:locals].merge!(@interface_data)
			my_ruleset = evaluate_rule hash_data do 

				if rules_by_element[element_name].is_a?(Array)
					rules_by_element[element_name].each do | str_rule |
						counter = counter + 1
						begin
							eval(str_rule)
						rescue Exception => e  
							puts "#{counter} => Evaluation of Interface rules failed"
							puts "#{str_rule}"
							#puts e.message  
							#puts e.backtrace.inspect 
						end
					end
				end
			end
			engine << my_ruleset
      return selected_elements(engine)
    end
		
   
	 def evaluate(facts, str_rules, interface_data = {})
			@facts = facts
			@interface_data = interface_data
			@rules_by_element = rules_by_element(str_rules)
			@selected = Hash.new
			
			@rules_by_element.each do | element, rules |
				result = evaluate_node(element, interface_data)
				@selected.merge!(result)
			end
			return compose(@hash) 
	 end
    
		def evaluate_extensions(extension_str)
			if extension_str.is_a?(String)
				eval(extension_str)
				@extention_list
			end
		end
		
		def extensions_hash
			@extention_list
		end
		
		#== PRIVATE METHODS
		private

		def selected_elements(engine)
			selected_elements = {}
			engine.each :_, "maps_to", :_ do | element |
				selected_elements[element[0]] ||= element[2]
			end
			return selected_elements
		end


		def compose(hash_tree)
			element_name = hash_tree[:name]
			
			if @selected[element_name].is_a?(Hash) #== Checks if node was previously selected by the first evaluation
				hash_tree[:node_content] = @selected[element_name]
				@direct_node_ref[element_name] = true
				if hash_tree[:children].is_a?(Array)
					#== Generates reapeatable nodes
          new_children = repeatable_children_nodes(hash_tree)
					unless new_children.nil? 
            hash_tree[:children] = new_children
						
					else
            hash_tree[:children].each_index do |index|
              selected = compose(hash_tree[:children][index])
              hash_tree[:children][index] = nil unless selected #== if it was not selected by the rules, clear the node.
            end
            hash_tree[:children].compact! #== Remove blank nodes (unselected by rules)
          end
				end
			else
				return false
			end
			return hash_tree
		end
		
		def get_cloned_node_name( name )
			@cloned_nodes_by_source[ name ] ||= { total: 0, clones: Array.new }
			@cloned_nodes_by_source[ name ][:total] = @cloned_nodes_by_source[ name ][:total] + 1 
			new_name = "#{name}_#{@cloned_nodes_by_source[ name ][:total]}"
			@cloned_nodes_by_source[ name ][:clones] << new_name
			return new_name
		end
		
	
		def populate_cloned_children(children, node_values)
      children.each_index do |index|
		 
				#-- Populates with values of selected node
				selected_node = evaluate_node(children[index][:name], node_values) #== Recursive interface data is sent to evaluation
				if selected_node[children[index][:name]].is_a?(Hash)
					source_node_name = children[index][:name]
					children[index][:node_content] = selected_node[children[index][:name]]
					#-- rename the new node
					source_node_name ||= rand(36**8).to_s(36)
					children[index][:name] = get_cloned_node_name(source_node_name)
					#-- Has children?
					unless children[index][:children].nil?
						new_children = repeatable_children_nodes(children[index], node_values) #== For Nested collections
						unless new_children.nil?
							children[index][:children] = new_children
						else
							populate_cloned_children(children[index][:children], node_values) 
						end
					end
				else
					children[index] = nil
				end

      end
			return children.compact!
    end
		
		
		def repeatable_children_nodes(current_node, node_values = Hash.new)
      
      if current_node[:repeatable] == true
        new_children = [] #== For children populated with collection
				collection = current_node[:node_content][:params][:collection]
				iterator_name = current_node[:node_content][:params][:as] || 'value'
				
        if collection.is_a?(Array)
					collection.each do | instance_value |
						children_clone = Marshal.load( Marshal.dump(current_node[:children]) ) #== Clonning nodes
						
						current_value = Hash.new
						current_value[iterator_name] = instance_value
						node_values.merge!(current_value)
						
						populate_cloned_children(children_clone, node_values)
						new_children = new_children + children_clone #== Add clonned nodes in the tree

					end
  				return new_children
				end
      end
      
    end
		
		
		
		
		#== Extension method
		#== extend nodes: ['name_field', 'age_field', 'age_field' ], :extension => 'HTMLLineBreak'
		#== {:name => 'ext2', :extension => 'HTMLLineBreak', :nodes => ['name_field', 'age_field', 'age_field' ]},
		def extend(hash)
			if hash.is_a?(Hash)
				#hash[:name] = "#{hash[:extension]}_#{rand(36**8).to_s(36)}"
				#hash[:name] = hash[:extension]
				new_nodes = Array.new
				hash[:nodes].each{ | node |
					if @direct_node_ref[ node ] == true
						new_nodes << node
					else
						new_nodes = new_nodes + @cloned_nodes_by_source[ node ][:clones] if @cloned_nodes_by_source[ node ].is_a?(Hash)
					end
				}
				hash[:nodes] = new_nodes
				@extention_list << hash
			end
		end
		
		
		def split_rules(str)
			rules = Array.new
			m = 0
			str.each_line do | line |
				unless line.match(/^[\s]*#.*$/)
					m = m + 1 if line.match(/^.*?maps_to.+$/)
					rules[m] ||= ""
					rules[m] << line
				end
			end
			return rules
		end
		
		def rules_by_element(str)
			rules_array = split_rules(str).compact!
			rules_hash = Hash.new
			rules_array.each do | str_rule |
				unless str_rule.nil?
					match = str_rule.match(/maps_to.+?abstract.+?['"](.+?)['"]/)
					unless match.nil?
						abstract_name = match[1]
						rules_hash[abstract_name] ||= Array.new
						rules_hash[abstract_name] << str_rule
					end
				end
			end
			return rules_hash
		end
		
  end
	
end