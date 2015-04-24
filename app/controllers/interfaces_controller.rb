class InterfacesController < ApplicationController

  # GET /interfaces
  # GET /interfaces.xml
  def index
    @interfaces = SWUI::Interface.find_all    
  end
	
	# GET /interfaces/new
  # GET /interfaces/new.xml
  def new
    respond_to do |format|
			format.html # new.html.erb
      format.xml  { render :xml => @interface }
    end
  end
	
	# POST /interfaces
  # POST /interfaces.xml
  def create
    @interface = SHDM::Interface.create(params[:interface])
    
    respond_to do |format|
      if @interface.save
        flash[:notice] = 'Interface was successfully created.'
        format.html { redirect_to :action => 'edit', :id => @interface }
        format.xml  { render :xml => @interface, :status => :created, :location => @interface }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @interface.errors, :status => :unprocessable_entity }
      end
    end
  end
	
	# GET /interfaces/1/edit
  def edit
    @interface  = SWUI::Interface.find(params[:id])
  end
	
  # PUT /interfaces/1
  # PUT /interfaces/1.xml
  def update
    @interface = SWUI::Interface.find(params[:id])
		current_panel = params.delete(:current_panel)
		params.delete(:highlight)
    respond_to do |format|
      if @interface.update_attributes(params[:interface])
        flash[:notice] = 'Interface was successfully updated.'
				format.html { redirect_to( params[:commit] == 'Save' ? interfaces_url : current_panel ) }
				format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @interface.errors, :status => :unprocessable_entity }
      end
    end
  end
	
	# DELETE /interfaces/1
  # DELETE /interfaces/1.xml
  def destroy
    @interface = SWUI::Interface.find(params[:id])
    @interface.destroy

    respond_to do |format|
      format.html { redirect_to(interfaces_url) }
      format.xml  { head :ok }
    end
  end
	
	def widget_manifest
		widget_name = params[:id]
		unless widget_name.nil? 
			@widget_hash = @template.widget_manifest_hash(widget_name) 
			respond_to do |format|
				if @widget_hash.is_a?(Hash)
					format.html { render :layout => false }
				else
					format.html { render :text => "<h2>Manifest file not found for #{widget_name}</h2>" }
				end
				
			end
		end
	end
	
end
