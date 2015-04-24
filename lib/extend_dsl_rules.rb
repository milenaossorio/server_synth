require "wongi-engine"
module ExtendDSLRules
  include Wongi::Engine
	
	#=== Defining new Wong methods
	module Wongi::Engine
		class Network
			def productions
				 @productions
			end
		end
		
		class Ruleset
			#== New rules methods

			def set(rule_name = "rule", &block)	
				hash_data = @_data
				def self.method_missing(m, *args, &block)  
					unless @_data.nil?
						return  @_data[:instance_variables][m] || @_data[:locals][m] || nil
					end
				end 

				rule_inst = ProductionRule.new rule_name
        @rules << rule_inst
				rule_inst.instance_eval{
					
					#== Metaprogramming -> Instance interface variables as local variables of rule
					unless hash_data.nil?
						rule_inst.instance_variable_set( :@_data, hash_data ) 
						hash_data[:instance_variables].each{ | k, v | rule_inst.instance_variable_set( eval(":@#{k}"), v ) } 
						
						hash_data[:locals].each{ | k, v |	
							rule_inst.class.module_eval { attr_accessor k.to_sym }
							eval("rule_inst.#{k.to_s} = v")
							}
					end

					if block_given?
						forall &block 
						make{	gen rule_name, "selected", true	}
					else
						forall { }
						make{ gen rule_name, "selected", true	}
					end
				}
				
				return rule_inst
		  end
			
			
			def maps_to(hash, &block)
        hash_data = @_data
				def self.method_missing(m, *args, &block)  
					unless @_data.nil?
						return  @_data[:instance_variables][m] || @_data[:locals][m] || nil
					end
				end 

				rule_inst = ProductionRule.new hash[:abstract]
        @rules << rule_inst
				rule_inst.instance_eval{
					
					#== Metaprogramming -> Instance interface variables as local variables of rule
					unless hash_data.nil?
						rule_inst.instance_variable_set( :@_data, hash_data ) 
						hash_data[:instance_variables].each{ | k, v | rule_inst.instance_variable_set( eval(":@#{k}"), v ) } 
						
						hash_data[:locals].each{ | k, v |	
							rule_inst.class.module_eval { attr_accessor k.to_sym }
							eval("rule_inst.#{k.to_s} = v")
							}
					end

					if block_given?
							forall &block 
							make{ gen hash[:abstract], "maps_to", { concrete_widget: hash[:concrete_widget], params: hash[:params] } }
					else
						forall { }
						make{	gen hash[:abstract], "maps_to", { concrete_widget: hash[:concrete_widget], params: hash[:params] } }
					end
				}
				
				return rule_inst
			end
			
			
		end
	end


def evaluate_rule(hash_data = Hash.new, &definition)
	rs = Wongi::Engine::Ruleset.new
	
	#== Metaprogramming -> Instance interface variables as local variables of ruleset
	unless hash_data.nil?
		rs.instance_variable_set( :@_data, hash_data ) 
		hash_data[:instance_variables].each{ | k, v | 
			rs.instance_variable_set( eval(":@#{k}"), v ) 
			instance_variable_set( eval(":@#{k}"), v )
		} 
		hash_data[:locals].each{ | k, v |	
			rs.class.module_eval { attr_accessor k.to_sym }
			eval("rs.#{k.to_s} = v")	
			
		}
	end
	rs.instance_eval &definition if block_given?
  rs
end 
	
	#=== New DSL terms
	class GreaterThanTest < FilterTest
	
		attr_reader :x, :y

		def initialize x, y
			@x, @y = x, y
		end

		def passes? token
			x = if Wongi::Engine::Template.variable? @x
				token[@x]
			else
				@x
			end
			y = if Wongi::Engine::Template.variable? @y
				token[@y]
			else
				@y
			end
			return x > y
		end

	end

	class LessThanTest < FilterTest
		attr_reader :x, :y
		def initialize x, y
			@x, @y = x, y
		end

		def passes? token
			x = if Wongi::Engine::Template.variable? @x
				token[@x]
			else
				@x
			end
			y = if Wongi::Engine::Template.variable? @y
				token[@y]
			else
				@y
			end
			return x < y
		end

	end


	class GreaterThanEqualTest < FilterTest

			attr_reader :x, :y

			def initialize x, y
				@x, @y = x, y
			end

			def passes? token
				x = if Wongi::Engine::Template.variable? @x
					token[@x]
				else
					@x
				end
				y = if Wongi::Engine::Template.variable? @y
					token[@y]
				else
					@y
				end
				return x >= y
			end

		end

	class LessThanEqualTest < FilterTest
		attr_reader :x, :y
		def initialize x, y
			@x, @y = x, y
		end

		def passes? token
			
			x = if Wongi::Engine::Template.variable? @x
				token[@x]
			else
				@x
			end
			y = if Wongi::Engine::Template.variable? @y
				token[@y]
			else
				@y
			end
			return x <= y
		end

	end
	
	class LikeTest < FilterTest
		attr_reader :x, :y
		def initialize x, y
			@x, @y = x, y
		end

		def passes? token
			
			x = if Wongi::Engine::Template.variable? @x
				token[@x]
			else
				@x
			end
			y = if Wongi::Engine::Template.variable? @y
				token[@y]
			else
				@y
			end
			if x.is_a?(String) and y.is_a?(String)
				return !x.downcase.match(y.downcase).nil?
			else
				return false
			end
		end

	end
	
	
	dsl {
			section :forall
			
			clause :greaterThan, :gt
			accept GreaterThanTest
			
			clause :lessThan, :lt
			accept LessThanTest
			
			clause :greaterThanEqual, :gte
			accept GreaterThanEqualTest
			
			clause :lessThanEqual, :lte
			accept LessThanEqualTest
			
			clause :like, :as
			accept LikeTest
	}
end