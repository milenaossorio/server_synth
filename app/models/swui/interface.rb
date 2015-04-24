require "interface-rules"
require "pp"

SWUI::Interface

module SWUI
	class SWUI::Interface 
		
		# Interface properties
		property SWUI::interface_name, 'rdfs:subPropertyOf' => RDFS::label
		property SWUI::interface_selection_rule
		property SWUI::interface_weight
		property SWUI::interface_title
		property SWUI::interface_description_type
		property SWUI::abstract_scheme
		property SWUI::abstract_rules
		property SWUI::concrete_mapping_rules
		property SWUI::concrete_extensions
		
		# Legacy properties (for concrete interfaces)
		property SWUI::abstract_spec
		property SWUI::concrete_interface_code
		
		#== Class methods
		
    def self.get_interface(facts_triples = [], interface_data = {})
      selected_interface = self.select_interface(facts_triples, interface_data)
      unless selected_interface.nil?
				if selected_interface.interface_description_type.to_s == "Abstract" 
					self.make_interface(selected_interface, facts_triples, interface_data)
				else
					selected_interface.abstract_spec.to_s
				end
			else
				raise "NO INTERFACE RULE WAS MATCHED"
			end
      
    end
		
		def self.interfaces_by_weight
			interfaces = SWUI::Interface.find_all
			interfaces.sort!{ | x, y | (x.interface_weight.to_s.to_i || 0) <=> (y.interface_weight.to_s.to_i || 0) }
		end
		
    def self.select_interface(facts_triples, interface_data)
      for interface in SWUI::Interface.interfaces_by_weight do
        if interface.evaluate_selection_rule(facts_triples, interface_data)
          puts "SELECTED INTERFACE: #{interface.interface_title}"
					return interface 
        end
      end
			return nil
    end
    
    #== Instance methods
		def evaluate_selection_rule(facts_triples = [], interface_data)
			
			unless self.interface_selection_rule.empty?
				instance_rule = InterfaceRules::SelectionRule.new( self.interface_selection_rule.to_s, interface_data )
        #== Adding facts
				instance_rule.add_facts(facts_triples)
				return instance_rule.is_true?
			end
		end

    
		private
		
		
		def self.make_interface(selected_interface, facts_triples, interface_data)
			
			abstract_scheme = eval(selected_interface.abstract_scheme.to_s)
			if abstract_scheme.is_a?(Hash)
				abstract_rules_str = selected_interface.abstract_rules.to_s
				
				#== Instances and evaluates the selected abstract interface
				abstract_interface_rules =  InterfaceRules::AbstractInterface.new( abstract_scheme )
				abstract_composed_hash = abstract_interface_rules.evaluate( facts_triples, abstract_rules_str, interface_data )
			 
				#== Concrete mapping
				concrete_mapping_rules_str = selected_interface.concrete_mapping_rules.to_s
				 
				unless concrete_mapping_rules_str.empty?
					concrete_interface_rules =  InterfaceRules::ConcreteInterface.new( abstract_composed_hash )
					concrete_composed_hash = concrete_interface_rules.evaluate( facts_triples, concrete_mapping_rules_str, interface_data )
					hash_extensions = concrete_interface_rules.evaluate_extensions( selected_interface.concrete_extensions.to_s )
					#== Concrete rendering
					if  concrete_composed_hash.is_a?(Hash)
						concrete_interface = ConcreteWidget::Interface.new(concrete_composed_hash)
						concrete_interface.add_extensions(hash_extensions)
						return concrete_interface.render
					else
						return "No interface could be composed"
					end
				end
				
			end
		end
		
		
		
	end
end