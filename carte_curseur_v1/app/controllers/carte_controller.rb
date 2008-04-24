class CarteController < ApplicationController
  
  before_filter :initialise_periode
  
  def initialise_periode
    @debut_periode = 1946
    @fin_periode = 2003
  end
# quand je fais des tests sur les sliders  
#  def slider
#    list
#    render :action => 'slider_test'
#  end
  
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
  
  # fonction qui met-a-jour la carte en modifiant le fichier des donnees a afficher
  def update_map
    
    # recuperation du jeu de donnees choisi et de la variable a cartographier
    # pour l'instant en dur le dataset 1 et la variable 8
    @dataset = Dataset.find(1)
    @variable = Variable.find(8)    

    # constitution du jeu de donnees a afficher, en creant un code pays fips-annees correspondant au code cow pour une date donnee (en accord avec la carte)
    @data = ActiveRecord::Base.connection.select_all("SELECT dataset_#{@dataset.id}.var#{@dataset.identifierccode1_var} as ccode1, world.fips_cntry || world.begin || world.end as ccode, dataset_#{@dataset.id}.var#{@dataset.identifieryear_var} as year, dataset_#{@dataset.id}.var#{@variable.var_id} as data from dataset_#{@dataset.id}, fips_cow_codes, world where (dataset_#{@dataset.id}.var#{@dataset.identifierccode1_var} = fips_cow_codes.cowcode) and (fips_cow_codes.fips_cntry = world.fips_cntry) and (dataset_#{@dataset.id}.var#{@dataset.identifieryear_var} >= world.begin and dataset_#{@dataset.id}.var#{@dataset.identifieryear_var} <= world.end) ORDER BY dataset_#{@dataset.id}.var#{@dataset.identifieryear_var}, world.fips_cntry ")
    @pays = ActiveRecord::Base.connection.select_values("SELECT world.fips_cntry || world.begin || world.end  as ccode from world, fips_cow_codes, dataset_#{@dataset.id} where (dataset_#{@dataset.id}.var#{@dataset.identifierccode1_var} = fips_cow_codes.cowcode) and (fips_cow_codes.fips_cntry = world.fips_cntry) and (dataset_#{@dataset.id}.var#{@dataset.identifieryear_var} >= world.begin and dataset_#{@dataset.id}.var#{@dataset.identifieryear_var} <= world.end) group by world.fips_cntry || world.begin || world.end ORDER BY world.fips_cntry || world.begin || world.end ASC")
    @annees = ActiveRecord::Base.connection.select_values("SELECT var#{@dataset.identifieryear_var} as annee from world, fips_cow_codes, dataset_#{@dataset.id} where (dataset_#{@dataset.id}.var#{@dataset.identifierccode1_var} = fips_cow_codes.cowcode) and (fips_cow_codes.fips_cntry = world.fips_cntry) and (dataset_#{@dataset.id}.var#{@dataset.identifieryear_var} >= world.begin and dataset_#{@dataset.id}.var#{@dataset.identifieryear_var} <= world.end) group by var#{@dataset.identifieryear_var} ORDER BY var#{@dataset.identifieryear_var} ASC")
    @tableau = Array.new
    for annee in @annees
      @tableau[annee.to_i] = Hash.new()
      @pays.each do |pays|
        @tableau[annee.to_i][pays] = "#"
      end
    end
    
    for ligne in @data
      @tableau[ligne['year'].to_i][ligne['ccode']] = case when ligne['data'] == nil then nil else ligne['data'].to_f end
    end
#    render :inline =>    @tableau[1870..2003].to_json + @annees.to_json
#    render :inline =>    @annees.to_json

    # ouverture du fichier javascript en ecriture
    @data2_file=RAILS_ROOT + '/public/javascripts/src/donnees.js'
    open(@data2_file, 'w') do |f|
      for ane in @annees
        f.puts 'var AN' + ane + ' = new Array;'
        for pay in @pays        
          f.puts 'AN' + ane + '["' + pay + '"]="' + (@tableau[ane.to_i][pay]).to_s + '";'
        end
      end
#      f.write "hello world !"
    end

    render :action => 'update_map'
#    end
#    render :text => 'ok'
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
      #bricolage pour éviter une erreur car on a survolé un pays au lieu d'un conflit. FIX IT
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
      #bricolage pour éviter une erreur car on a survolé un pays au lieu d'un conflit. FIX IT
      #il faudrait éviter de faire un appel ajax
    render(:nothing => true) # affiche un partial vide ("")
    end
  end
 
end
