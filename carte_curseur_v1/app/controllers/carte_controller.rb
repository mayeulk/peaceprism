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
      @dataset = Dataset.find(6)
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
        
      # toutes les annees existantes pour la carte
      @annees2 = ActiveRecord::Base.connection.select_all(
        "SELECT annee from annees order by annee")
      
      tab_annees = Array.new()
      c = 0
      for elt in @annees2
        tab_annees[c] = elt['annee']
        c = c + 1
      end
      
      # tous les pays de la carte
      @pays2 = ActiveRecord::Base.connection.select_all(
        "SELECT world.fips_cntry || world.begin || world.end  as ccode
        from world order by world.fips_cntry || world.begin || world.end")
      
      tab_pays = Array.new()
      d = 0
      for eltt in @pays2
        tab_pays[d] = eltt['ccode']
        d = d + 1
      end      

      # recuperation de la table qui repertorie les pays inexistants 
      @diese = ActiveRecord::Base.connection.select_all("
        SELECT annee, ccode, diese, manquante FROM diese_null
        ORDER BY annee, ccode")
      
      # pour un souci de proprete, on pourra regrouper les deux boucles en une :
      # premiere : constitution du tableau de donnees
      tableau_donnees = Array.new()
      i = 0
      j = 0
      for t in @diese
        if t['diese'].to_i == 1
          tableau_donnees[i] = "#"
        else
          tableau_donnees[i] = "null"
        end
        
        if ((@data[j].values)[2] == t['annee']) and ((@data[j].values)[1] == t['ccode'])
          tableau_donnees[i] = (@data[j].values)[3]
          j = j + 1
        end
           
        i=i+1
      end
      
      # deuxieme : transformation en un hash de tableaux (plus facile pour l'affichage
      tab_do = Hash.new()
      com = 0
      for ann in tab_annees
        compt = 0
        ar = Array.new()
        for pa in tab_pays
          ar[compt] = tableau_donnees[com]
          com = com + 1
          compt = compt + 1
        end
        tab_do[ann] = ar
      end
        
      tab_envoi = Hash.new()
      
      tab_envoi['annees'] = tab_annees
      tab_envoi['pays'] = tab_pays
      tab_envoi['data'] = tab_do

      render :json => tab_envoi.to_json

      }
    end

        
#      
#      # seulement les pays compris dans le jeu de donnees
#      @pays = ActiveRecord::Base.connection.select_values("
#        SELECT world.fips_cntry || world.begin || world.end  as ccode 
#        FROM world, fips_cow_codes, dataset_#{@dataset.id} 
#        WHERE (#{@var_code} = fips_cow_codes.cowcode) 
#          and (fips_cow_codes.fips_cntry = world.fips_cntry) 
#          and (#{@var_annee} >= world.begin 
#          and #{@var_annee} <= world.end) 
#        GROUP BY world.fips_cntry || world.begin || world.end 
#        ORDER BY world.fips_cntry || world.begin || world.end ASC")
#
#      # seulement les annees pouvant etre affichees
#      @annees = ActiveRecord::Base.connection.select_values(
#        "SELECT DISTINCT #{@var_annee} as annee
#        from world, fips_cow_codes, dataset_#{@dataset.id}
#        where #{@var_annee} < 1960
#          and (#{@var_code} = fips_cow_codes.cowcode)
#          and (fips_cow_codes.fips_cntry = world.fips_cntry)
#          and (#{@var_annee} >= world.begin
#          and #{@var_annee} <= world.end)
#        group by #{@var_annee}
#        ORDER BY #{@var_annee} ASC")
#      
      
#      @tab = ActiveRecord::Base.connection.select_values(
#        "SELECT distinct annee, world.fips_cntry || world.begin || world.end  as ccode
#        FROM annees, world
#        WHERE annee >= (select min(dataset_1.var5) as min from dataset_1)
#          and annee <= (select max(dataset_1.var5) as max from dataset_1)
#        ORDER BY  annee, world.fips_cntry || world.begin || world.end")
#        
#        
#      @paysannees = ActiveRecord::Base.connection.select_values(
#        "SELECT fips_cntry, annee 
#        FROM world, annees
#        WHERE annee >= world.begin
#          and annee <= world.end")
#          
#      @annee_debut = @annees[0].to_i

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
