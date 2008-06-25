class CarteController < ApplicationController
  
before_filter :initialise_var
  
  def initialise_var
    @debut_periode = 1946
    @fin_periode = 2003
    @dataset_choisi = ""
    @datasets2 = Dataset.find(:all)
    @datasets = ActiveRecord::Base.connection.select_all(
    "Select data_set_full_name, id from datasets where id<10 order by id")
    @dat = {}
    for @d in @datasets
     @dat[@d['data_set_full_name']] = @d['id']
    end
  end
  
  def refresh_var
    @dataset_choisi = params[:datas]
    @var_select = ActiveRecord::Base.connection.select_all(
       "SELECT var_id, dataset_id, name, kind from variables 
          where (kind = 'monadic') and format != 'string' and dataset_id = #{@dataset_choisi} order by var_id")
    
    @va = {}
    for v in @var_select
      @va[v['name']] = v['var_id']
    end

    render :partial => "refresh_var"
  end
  
  
  def index
    list
    render :action => 'list'#, :content_type => "application/xhtml+xml", :layout => false
  end

# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
 #verify :method => :post, :only => [ :destroy, :create, :update ],
#         :redirect_to => { :action => :list }

  def list
    # cf. la variable "@headers" dans l'ensemble des fichiers de ivygis et le post
    # de Robert Thau ici: http://www.nabble.com/Does-Rails-suppports-XHTML-for-views-for-inline-SVG's--t1505395.html
    # We want to display graphic overlays, as inline SVG if possible.
    # For inline SVG to work, Firefox requires that the page be marked
    # in the HTTP header as containing "application/xhtml+xml".  But
    # IE gags on that.  So, we export that content-type only to browsers
    # that explicitly advertise that they support it.

    if (request.headers['HTTP_ACCEPT'].match(/application\/xhtml\+xml/))
      response.headers['type'] = "application/xhtml+xml; charset=utf-8"
      @browser="moz"
      
    else
      @browser="ie"
    end    
  end
  

#  def show
#      @conflitsext = Conflitsext.find(params[:id])
#  end

  def show_over
  @id=params[:id]
  @annee=params[:annee].to_i
    if @id.strip.match(/^lt/)
      @conflitsexts = Conflitsext.find(:all, :order => "begin ASC", :conditions => 'ltlgrd = \''+params[:id]+'\'')     
    else
      #bricolage pour éviter une erreur car on a survole un pays au lieu d'un conflit. FIX IT
      #il faudrait éviter de faire un appel ajax
    render(:nothing => true) # affiche un partial vide ("")
    end
  end
  
  def tableau
  @id=params[:id]
  @annee=params[:annee].to_i
    if @id.strip.match(/^lt/)
      @conflitsexts = Conflitsext.find(:all, :order => "begin ASC", :conditions => 'ltlgrd = \''+params[:id]+'\'')     
    else
      #bricolage pour eviter une erreur car on a survole un pays au lieu d'un conflit. FIX IT
      #il faudrait eviter de faire un appel ajax
    render(:nothing => true) # affiche un partial vide ("")
    end
  end
 
end
