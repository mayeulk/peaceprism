class CarteController < ApplicationController
  
before_filter :initialise_var
  # initialise les variables ruby au chargement de la page
  def initialise_var
    @debut_periode = 1946
    @fin_periode = 2003
    @dataset_choisi = ""
    @datasets2 = Dataset.find(:all)
    @datasets = ActiveRecord::Base.connection.select_all(
    "Select data_set_full_name, id from datasets where id<10 order by id")
   
    # la liste des datasets disponibles pour le select html
    @dat = Array.new()
    @dat[0] = ['Please choose a dataset', '0']
    i= 1    
    for @d in @datasets
      option = Array.new()
      option[0] = @d['data_set_full_name']
      option[1] = @d['id']
      @dat[i] = option
      i += 1
    end
  end
  
  # rempli le tableau des variables appartenant au dataset choisi, et rend le partiel
  # avec la liste deroulante de variables
  def refresh_var
    @dataset_choisi = params[:datas]
    if @dataset_choisi != '0'
      @citation = ActiveRecord::Base.connection.select_value(
      "Select data_set_citation from datasets where id = #{@dataset_choisi}")
      @var_select = ActiveRecord::Base.connection.select_all(
         "SELECT var_id, name, long_name from variables 
            where (kind = 'monadic') and format != 'string'
            and dataset_id = #{@dataset_choisi} order by var_id")
      
      # la liste des variables disponibles sous forme d'un tableau
      @vars = Array.new()
      @vars[0] = ['Please choose a variable', '0']
      i= 1
      for @v in @var_select
        option = Array.new()
        # on met .to_s pour les tests tant que la base n'est pas remplie (si le nom long est absent, on fait nil.to_s)
        option[0] = @v['long_name'].to_s + ' (' + @v['name'] + ')'
        option[1] = @v['var_id']
        @vars[i] = option
        i += 1
      end
      
      render :partial => "refresh_var"
    else
      render :inline => "<script type='text/ecmascript'>requestjson(0,0)</script>"
    end
  end
  
  # rend l'action 'list' (c'est a dire affiche la page 'carte')
  def index
    list
    render :action => 'list'#, :content_type => "application/xhtml+xml", :layout => false
  end

# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
 #verify :method => :post, :only => [ :destroy, :create, :update ],
#         :redirect_to => { :action => :list }

  # affiche la page selon le navigateur (firefox ou ie)
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
  
end
