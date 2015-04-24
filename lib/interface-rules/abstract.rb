module InterfaceRules
 
  #VERSION '0.1.1'
  require "rubygems"

  class InterfaceRules::AbstractInterface
		 
		 include ExtendDSLRules
    def initialize(hash)
			@hash = hash
		end
		
		def hash
			@hash
		end
		
    def evaluate(facts, str_rules, interface_data)
			engine = Wongi::Engine.create
			facts.each{| fact | engine << fact }
			
      #engine << ruleset{ eval(str_rules) }
			hash_data = { :locals => interface_data, :instance_variables => {} }
      
			my_ruleset = evaluate_rule hash_data do 
				eval(str_rules)
			end
			engine << my_ruleset
      selected = selected_elements(engine)
			return compose(@hash, selected, engine.productions)
		end	

		private

		def selected_elements(engine)
			selected_elements = {}
			engine.each :_, "selected", true do | element |
				selected_elements[element.first] = true
			end
			return selected_elements
		end


		def compose(hash_tree, selected_elements, production_rules)
			element_name = hash_tree[:name]
			if selected_elements[element_name] or not production_rules[element_name]
				if hash_tree[:children].is_a?(Array)
					hash_tree[:children].each_index do |index|
						selected = compose(hash_tree[:children][index], selected_elements, production_rules)
						unless selected
							hash_tree[:children][index] = nil
						end
					end
					hash_tree[:children].compact!
				end
			else
				return false
			end
			return hash_tree
		end


		
  end
end