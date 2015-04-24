require "wongi-engine"

module InterfaceRules

	class InterfaceRules::SelectionRule
		include ExtendDSLRules
		
		def initialize(str_rule, interface_data = {})
			@engine = Wongi::Engine.create
			
			if str_rule.is_a?(String)
				hash_data = { :locals => interface_data, :instance_variables => {} }
      
				my_ruleset = evaluate_rule hash_data do 
					eval(str_rule)
				end
				engine << my_ruleset
			end
		end
		
		def engine
			@engine
		end
		def add_facts(facts)
			facts.each{| fact | @engine << fact }
		end
		
		def << (fact)
			@engine << fact
		end
		
		def is_true?()
			@engine.each :_, :_, :_ do | element |
				puts element
			end
			
			@engine.each :_, "selected", true do | element |
				return true
			end
			return false
		end
		
		
	end
end
