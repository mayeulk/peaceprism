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
    respond_to do |wants|
      wants.json {
    
      #@vari = params[:variable]
      # recuperation du jeu de donnees choisi et de la variable a cartographier
      # pour l'instant en dur le dataset 1 et la variable 8
      @dataset = Dataset.find(1)
      @variable = Variable.find(8) 
      
      @var_annee = "dataset_#{@dataset.id}.var#{@dataset.identifieryear_var}"
      @var_code = "dataset_#{@dataset.id}.var#{@dataset.identifierccode1_var}"

      # constitution du jeu de donnees a afficher, en creant un code pays
      # fips-annees correspondant au code cow pour une date donnee
      # (en accord avec la carte) seulement les donnees affichables
      @data = ActiveRecord::Base.connection.select_all("
        SELECT #{@var_code} as ccode1,
          world.fips_cntry || world.begin || world.end as ccode,
          #{@var_annee} as year, 
          dataset_#{@dataset.id}.var#{@variable.var_id} as data
        FROM dataset_#{@dataset.id},  fips_cow_codes,  world
        WHERE #{@var_annee} < 2004
          and (#{@var_code} = fips_cow_codes.cowcode)
          and (fips_cow_codes.fips_cntry = world.fips_cntry)
          and (#{@var_annee} >= world.begin
          and #{@var_annee} <= world.end)
        ORDER BY  #{@var_annee},
          world.fips_cntry || world.begin || world.end
        ")
      
      # seulement les pays compris dans le jeu de donnees
      @pays = ActiveRecord::Base.connection.select_values("
        SELECT world.fips_cntry || world.begin || world.end  as ccode 
        FROM world, fips_cow_codes, dataset_#{@dataset.id} 
        WHERE (#{@var_code} = fips_cow_codes.cowcode) 
          and (fips_cow_codes.fips_cntry = world.fips_cntry) 
          and (#{@var_annee} >= world.begin 
          and #{@var_annee} <= world.end) 
        GROUP BY world.fips_cntry || world.begin || world.end 
        ORDER BY world.fips_cntry || world.begin || world.end ASC")

      # seulement les annees pouvant etre affichees
      @annees = ActiveRecord::Base.connection.select_values(
        "SELECT DISTINCT #{@var_annee} as annee
        from world, fips_cow_codes, dataset_#{@dataset.id}
        where #{@var_annee} < 1960
          and (#{@var_code} = fips_cow_codes.cowcode)
          and (fips_cow_codes.fips_cntry = world.fips_cntry)
          and (#{@var_annee} >= world.begin
          and #{@var_annee} <= world.end)
        group by #{@var_annee}
        ORDER BY #{@var_annee} ASC")
      
      # toutes les annees existantes pour la carte
      @annees2 = ActiveRecord::Base.connection.select_values(
        "SELECT annee from annees where annee < 1950 order by annee")
      
      # tous les pays de la carte
      @pays2 = ActiveRecord::Base.connection.select_values(
        "SELECT world.fips_cntry || world.begin || world.end  as ccode
        from world order by world.fips_cntry || world.begin || world.end")
      
      @tab = ActiveRecord::Base.connection.select_values(
        "SELECT distinct annee, world.fips_cntry || world.begin || world.end  as ccode
        FROM annees, world
        WHERE annee >= (select min(dataset_1.var5) as min from dataset_1)
          and annee <= (select max(dataset_1.var5) as max from dataset_1)
        ORDER BY  annee, world.fips_cntry || world.begin || world.end")
        
      @annee_debut = @annees[0].to_i
      tableau_donnees = Hash.new()
  #    for annee in @annees
  #      @tableau_donnees[annee.to_i-@annee_debut] = Array.new()
  #      @pays.each do |pays|
  #        @tableau_donnees[annee.to_i-@annee_debut][pays] = "#"
  #      end
  #    end
#      i = 0
#      for annee in 0..(@annees2.length-1)
      j = 0
      for annee2 in @annees2
        @tab_temp = Hash.new() #une annee, tous les pays
#        for p in 0..(@pays2.length-1)
        for p in @pays2
          @tab_temp[p] = "#"
#           @tab_temp[p] = @data[i]
#          @tab_temp[p] = (@data[i])['data']
          if ((@data[j].values)[2] == annee2) and ((@data[j].values)[1] == p)
            @tab_temp[p] = ((@data[j]).values)[3]
            j = j + 1
#            if j> #nombre 
#              break
#            end
          end
# decommenter lorsqu'on aura un tableau carre, sinon on cherche 
#(nb_annees x nb_pays) donnees, alors qu'on en a (nb_annees_pays_irrelevant) de moins
#          i = i + 1
        end
        tableau_donnees[annee2] = @tab_temp

      end

      render :json => tableau_donnees.to_json
#      render :json => @data.to_json
#      for ligne in @data
#        @tableau[ligne['year'].to_i-@annee_debut][ligne['ccode']] = case when ligne['data'] == nil then nil else ligne['data'].to_f end
#      end
      
  #    render :json => @annees.to_json

      
#      page.replace 'tatata', {:first=>"truc", :last=>"machin"}
#      render :update do |page|
#        for ligne in @data
#          @tableau[ligne['year'].to_i][ligne['ccode']] = case when ligne['data'] == nil then nil else ligne['data'].to_f end
#          page.assign 'AN' + ligne['year'], {:ligne['ccode']=>ligne['data'].to_f}
#        end
#      end
      }
    end
    
#    @vari = params[:variable]
    # recuperation du jeu de donnees choisi et de la variable a cartographier
    # pour l'instant en dur le dataset 1 et la variable 8
#    @dataset = Dataset.find(1)
#    @variable = Variable.find(@vari)    

    # constitution du jeu de donnees a afficher, en creant un code pays fips-annees correspondant au code cow pour une date donnee (en accord avec la carte)
#    @data = ActiveRecord::Base.connection.select_all("SELECT dataset_#{@dataset.id}.var#{@dataset.identifierccode1_var} as ccode1, world.fips_cntry || world.begin || world.end as ccode, dataset_#{@dataset.id}.var#{@dataset.identifieryear_var} as year, dataset_#{@dataset.id}.var#{@variable.var_id} as data from dataset_#{@dataset.id}, fips_cow_codes, world where (dataset_#{@dataset.id}.var#{@dataset.identifierccode1_var} = fips_cow_codes.cowcode) and (fips_cow_codes.fips_cntry = world.fips_cntry) and (dataset_#{@dataset.id}.var#{@dataset.identifieryear_var} >= world.begin and dataset_#{@dataset.id}.var#{@dataset.identifieryear_var} <= world.end) ORDER BY dataset_#{@dataset.id}.var#{@dataset.identifieryear_var}, world.fips_cntry ")
#    @pays = ActiveRecord::Base.connection.select_values("SELECT world.fips_cntry || world.begin || world.end  as ccode from world, fips_cow_codes, dataset_#{@dataset.id} where (dataset_#{@dataset.id}.var#{@dataset.identifierccode1_var} = fips_cow_codes.cowcode) and (fips_cow_codes.fips_cntry = world.fips_cntry) and (dataset_#{@dataset.id}.var#{@dataset.identifieryear_var} >= world.begin and dataset_#{@dataset.id}.var#{@dataset.identifieryear_var} <= world.end) group by world.fips_cntry || world.begin || world.end ORDER BY world.fips_cntry || world.begin || world.end ASC")
#    @annees = ActiveRecord::Base.connection.select_values("SELECT var#{@dataset.identifieryear_var} as annee from world, fips_cow_codes, dataset_#{@dataset.id} where (dataset_#{@dataset.id}.var#{@dataset.identifierccode1_var} = fips_cow_codes.cowcode) and (fips_cow_codes.fips_cntry = world.fips_cntry) and (dataset_#{@dataset.id}.var#{@dataset.identifieryear_var} >= world.begin and dataset_#{@dataset.id}.var#{@dataset.identifieryear_var} <= world.end) group by var#{@dataset.identifieryear_var} ORDER BY var#{@dataset.identifieryear_var} ASC")
#    @tableau = Array.new
#    for annee in @annees
#      @tableau[annee.to_i] = Hash.new()
#      @pays.each do |pays|
#        @tableau[annee.to_i][pays] = "#"
#      end
#    end
    
#    render :inline =>    @tableau[1870..2003].to_json + @annees.to_json
#    render :inline =>    @annees.to_json



    # ecriture du fichier de creation des variables en dur, bien sur, apres le systeme me dit
    # qu'il est pas synchronis� !!!

    # ouverture du fichier javascript en ecriture
#    @data2_file=RAILS_ROOT + '/public/javascripts/src/donnees.js'
#    open(@data2_file, 'w') do |f|
#      for ane in @annees
#        f.puts 'var AN' + ane + ' = new Array;'
#        for pay in @pays        
#          f.puts 'AN' + ane + '["' + pay + '"]="' + (@tableau[ane.to_i][pay]).to_s + '";'
#        end
#      end
#    end

#    render :action => 'update_map'
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
