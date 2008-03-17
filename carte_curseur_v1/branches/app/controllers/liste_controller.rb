class ListeController < ApplicationController
  def couleur_dessaturee(r,g,b,opac)
  #fournir r g b de 0 à 255 et opac(ité) de 0 à 1
    "rgb("+r*opac.to_i.to_s+","+g*opac.to_i.to_s+","+b*opac.to_i.to_s+")"
  end


  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @conflitsext_pages, @conflitsexts = paginate :conflitsexts, :per_page => 10
  end

  def show
    @conflitsext = Conflitsext.find(params[:id])
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
  
  def gras
    render(:layout => false)
# $('lt-16.5lg-68.15rd50').font.size = 12


  end
end
