# interpreter.rb -- Module that composes and renders a interface through an interface schema.
# Author:: Vagner Nascimento (vagnernascimento@gmail.com)

module ConcreteWidget
  #VERSION '0.1.2'
  #require "rubygems"
	require "tree"
  require "interface-rules/concrete-widget/widget-base"

  class Interface
    
    def initialize(hash_tree)
      @direct_ref_node = Hash.new
      @cloned_node_by_source = Hash.new
      @node_index_counter = 0
      @tree = compose(hash_tree)
      
    end
    
    def tree
      @tree
    end
    
    def direct_ref_node
      @direct_ref_node
    end
        
    # Returns a Ruby Tree version of the interface from a hash tree.
    def compose(hash_tree,parent = nil)
      #begin
       
        node, children = new_node_and_children(hash_tree, parent)
        if children
          children = repeatable_children_nodes(children, node)
          children.each do |child|
            node << compose(child, node)
          end 
        end
        return node
      #rescue LoadError => e
      #  warn "The Hash tree cannot be loaded"
      #end
    end
    
    
    def add_extensions(extensions)
      @extensions = extensions
      @extensions.each{ |ext|
        ext[:params] ||= {}
        ext[:nodes].each{ |node|
          ext[:params][:index] = ext[:nodes].index(node)
          name = ext[:name] || "#{ext[:extension]}_#{node}"
          ext[:params][:name] ||= name
          ext[:params][:id] ||= name   
          instance = extension_instance(ext[:extension], ext[:params]) 
          instance = widget_instance(ext[:extension], ext[:params]) if instance.nil?
          instance.target = direct_ref_node[ext[:params][:target]].content unless ext[:params][:target].nil?
          direct_ref_node[node].content.add_extension( instance ) unless direct_ref_node[node].nil?
          #-- Cloned nodes
          if @cloned_node_by_source[node].is_a?(Array)
            @cloned_node_by_source[node].each{ |clone_name|
              direct_ref_node[clone_name].content.add_extension( instance )
            }
          end
          check_extension_dependencies(instance)
        }
      }
    end
    
    # Run a Depth-first search (DFS) L -> R to render a interface
    def render(tree=nil)
      tree = @tree if tree.nil?
      tree.children.each{|node|
        node.parent.content << render(node)
      } if tree.has_children?
      check_dependencies(tree)
      return tree.content.render if tree.content.respond_to?(:render)
    end
    
    private
    
    def widget_instance(name, params)
      #load "concrete-widget/#{name}/#{name}.rb"
      require "interface-rules/concrete-widget/#{name}/#{name}"
      klass = eval(name)
      klass.new(params) unless klass.nil?
    end
    
    def extension_instance(name, params)
      begin
        #load "extensions/#{name}/#{name}.rb"
        require "interface-rules/extensions/#{name}/#{name}"
        klass = eval(name)
        klass.new(params) unless klass.nil?
      rescue LoadError => e
        return
      end
    end
    
    # There are two categories of dependencies: explicit (where node Id is specified) and by type (searching the first node compatible).
    # Attention: Experimental mechanism
    def check_dependencies(tree)
        if tree.content.respond_to?(:dependencies)
          if tree.content.respond_to?(:depends_on_ids) and not tree.content.depends_on_ids.nil?
            # Node ID is directly specified
            condition = Proc.new{|node| node.name == tree.content.depends_on_ids.first}
          else 
            # When no node ID is directly specified, the first node found compatible will be selected
            condition = Proc.new{|node| node.content.class.to_s == tree.content.dependencies.first.to_s} 
          end
          @direct_ref_node.each{|i,node| 
            if condition.call(node)
              tree.content.run_dependencies(node.content)
              return
            end
          }
        end
    end
    
    def check_extension_dependencies(ext)
      if ext.respond_to?(:dependencies)
        if ext.respond_to?(:depends_on_ids) and not ext.depends_on_ids.nil?
          # Node ID is directly specified
          condition = Proc.new{|node| node.name == ext.depends_on_ids.first}
        else 
          # When no node ID is directly specified, the first node found compatible will be selected
          condition = Proc.new{|node| node.content.class.to_s == ext.dependencies.first.to_s} 
        end
        @direct_ref_node.each{|i,node| 
          if condition.call(node)
            ext.run_dependencies(node.content)
            return
          end
        }
      end
    end
    
    
    def new_node_and_children(hash_tree, parent)
      #-- Add properties
      @node_index_counter+=1
      
      name = hash_tree[:name]
      name =  rand(36**8).to_s(36)+ '_' + @node_index_counter.to_s if name.nil?
      
      node_content = hash_tree[:node_content]
      node_content[:params] ||= {}
      node_content[:params][:name] ||= name
      node_content[:params][:id] ||= name
      node_content[:params][:extensions] = []
      children = hash_tree[:children]
      #-- Widget instance
      content = widget_instance(node_content[:concrete_widget], node_content[:params])
      #-- Tree node
      node = Tree::TreeNode.new(node_content[:params][:name], content)
      node.content.params = node_content[:params]
			node.content.parent = parent.content unless parent.nil?
      #-- Direct reference 
      @direct_ref_node[node_content[:params][:name]] = node
      return node, children
    end
    
    def populate_cloned_children(children, value, counter_parent, counter = 0)
      children.each do |child|
        #-- Populate with new values
        child[:node_content][:params] ||= {}
				if not child[:name].nil? 
				#if not child[:name].nil? and value[child[:name].to_sym].is_a?(Hash)
          node_params = value[child[:name].to_sym] 
					begin
						if node_params.nil? and not value.send(child[:name].to_sym).nil?
							node_params = {:content => value.send(child[:name].to_sym).label.to_s}
						end
					rescue
					
					end
					child[:node_content][:params].merge!( node_params || {} )
        end
        source_name = child[:name]
        #-- rename the node
        child[:name] ||= rand(36**8).to_s(36)
        child[:name] = child[:name] + '_'+ counter_parent.to_s + '_' + counter.to_s
        
        unless source_name.nil?
          @cloned_node_by_source[source_name] ||= [] 
          @cloned_node_by_source[source_name] << child[:name] unless child[:name].nil?
        end
        
        populate_cloned_children(child[:children], value, counter_parent, counter + 1) unless child[:children].nil?
      end
    end
    
    def repeatable_children_nodes(children, current_node)
      
      if current_node.content.params[:repeatable] == true
        c = 0
        new_children = []
        current_node.content.params[:values].each do | value |
          children_clone = Marshal.load( Marshal.dump(children) ) #== Clonning nodes
          populate_cloned_children(children_clone, value, c+=1)
          new_children = new_children + children_clone
        end
        return new_children
      else
        children
      end
      
    end
    
  end
end    