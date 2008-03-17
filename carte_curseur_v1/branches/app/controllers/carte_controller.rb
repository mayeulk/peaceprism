class CarteController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    # cf. la variable "@headers" dans l'ensemble des fichiers de ivygis et le post
    # de Robert Thau ici: http://www.nabble.com/Does-Rails-suppports-XHTML-for-views-for-inline-SVG's--t1505395.html
    # We want to display graphic overlays, as inline SVG if possible.
    # For inline SVG to work, Firefox requires that the page be marked
    # in the HTTP header as containing "application/xhtml+xml".  But
    # IE gags on that.  So, we export that content-type only to browsers
    # that explicitly advertise that they support it.

    if (@request.env['HTTP_ACCEPT'].match(/application\/xhtml\+xml/))
      @headers['Content-Type'] = "application/xhtml+xml; charset=utf-8"
      @browser="moz"
    else
      @browser="ie"
    end
  end

  def show
      @conflitsext = Conflitsext.find(params[:id])
  end

  def show_over
  @id=params[:id]
  @annee=params[:annee].to_i
    if @id.strip.match(/^lt/)
      @conflitsexts = Conflitsext.find(:all, :order => "begin ASC", :conditions => 'ltlgrd = \''+params[:id]+'\'')     
    else
      #bricolage pour éviter une erreur car on a survolé un pays au lieu d'un conflit. FIX IT
      #il faudrait éviter de faire un appel ajax
      render(:inline =>"<%= @begin1%>") # affiche un partial vide ("")
    end
  end

  def new
    @conflitsext = Conflitsext.new
  end

  def create
    @conflitsext = Conflitsext.new(params[:conflitsext])
    if @conflitsext.save
      flash[:notice] = 'Conflitsext was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @conflitsext = Conflitsext.find(params[:id])
  end

  def update
    @conflitsext = Conflitsext.find(params[:id])
    if @conflitsext.update_attributes(params[:conflitsext])
      flash[:notice] = 'Conflitsext was successfully updated.'
      redirect_to :action => 'show', :id => @conflitsext
    else
      render :action => 'edit'
    end
  end

  def destroy
    Conflitsext.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
