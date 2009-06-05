require 'activerecord' 
namespace :db do
  desc "Cree les fichiers json pour chaque variable"
  task(:create_fichiers_json => :environment) do
  
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

      # table repertoriant les annees-pays existants ou non 
      @diese = ActiveRecord::Base.connection.select_all("
        SELECT annee, ccode, diese, manquante FROM diese_null
        ORDER BY annee, ccode")
  
  #fin de la partie commune


  @variables = Variable.find(:all, :conditions => "id > 286 AND id <= 292") #"kind='monadic' AND format != 'string' 
  # dataset_id = 1 AND var_id=4 and 

  for @variable in @variables 
      @dataset = Dataset.find(@variable.dataset_id)     
      @var_annee = "dataset_#{@dataset.id}.var#{@dataset.identifieryear_var}"
      @var_code = "dataset_#{@dataset.id}.var#{@dataset.identifierccode1_var}"
      
      # recueil des donnees concernant la variable (pour le type de discretisation)
      @info = Hash.new()
      @info['var_id'] = @variable.var_id
      @info['dataset_id'] = @variable.dataset_id
      @info['name'] = @variable.name
      @info['kind'] = @variable.kind
      # cas 1 : variable binaire
      if @variable.binary_var == 1
        @info['format'] = 'boolean'
        @info['type'] = 'qualitatif'
        @info['unit'] = ""
        
        # s'il existe des variables qualitaives en plus
        @var_qual = ActiveRecord::Base.connection.select_all("
        SELECT value, meaning FROM var_labels WHERE var_id = #{@variable.var_id}")
 
        @tab_var = Hash.new()
        for elt in @var_qual
          @tab_var[elt['value']] = elt['meaning']
        end
        @info['var_qual'] = @tab_var
        
      else
        # cas : variable qualitative (pas de valeurs min ou max
        if @variable.mini == nil and @variable.maxi == nil
          @info['type'] = 'qualitatif'
          @info['format'] = @variable.format
          @info['unit'] = ""
          @var_qual = ActiveRecord::Base.connection.select_all("
            SELECT value, meaning FROM var_labels WHERE var_id = #{@variable.var_id}")
            
          @tab_var = Hash.new()
          for elt in @var_qual
            @tab_var[elt['value']] = elt['meaning']
          end
          @info['var_qual'] = @tab_var
        else
          # cas : variable qualitative ordonnee
          if @variable.qualitatif_ordonne == 1
            @info['type'] = 'qualitatif_ordonne'
            @info['mini'] = @variable.mini
            @info['maxi'] = @variable.maxi
            @info['format'] = @variable.format
            @info['unit'] = ""
            
            @var_qual = ActiveRecord::Base.connection.select_all("
            SELECT value, meaning FROM var_labels WHERE var_id = #{@variable.var_id}")
 
            @tab_var_ordo = Hash.new()
            @tab_var_spe = Hash.new()
            for elt in @var_qual
              if ((elt['value']).to_i >= @variable.mini)and((elt['value']).to_i <= @variable.maxi)
                @tab_var_ordo[elt['value']] = elt['meaning']
              else
                # s'il existe des variables qualitaives en plus
                @tab_var_spe[elt['value']] = elt['meaning']
              end
            end
            @info['var_qual_ordo'] = @tab_var_ordo
            @info['var_qual'] = @tab_var_spe
            
          else
            # cas : quantitatif
            @info['type'] = 'quantitatif'
            @info['mini'] = @variable.mini
            @info['maxi'] = @variable.maxi
            @info['format'] = @variable.format
            @info['unit'] = @variable.unit
            
            # s'il existe des variables qualitaives en plus
            @var_qual = ActiveRecord::Base.connection.select_all("
            SELECT value, meaning FROM var_labels WHERE var_id = #{@variable.var_id}")
 
            @tab_var = Hash.new()
            for elt in @var_qual
              @tab_var[elt['value']] = elt['meaning']
            end
            @info['var_qual'] = @tab_var
          end
        end
      end

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
        

      
      # pour un souci de proprete, on pourra regrouper les deux boucles en une :
      # premiere : constitution du tableau de donnees
      tableau_donnees = Array.new()
      i = 0
      j = 0  #curseur de ligne du tableau dataset_n
      for t in @diese
        if t['diese'].to_i == 1
          tableau_donnees[i] = "#"
        else
          tableau_donnees[i] = "null"
        end
        if (!(@data[j].nil?) and #test obligatoire sinon erreur car parfois @data[j].nil? est vrai (pourquoi ?! Arrive meme quand il n'y a pas de valeur nulle dans la base) 
            (@data[j].values)[2] == t['annee']) and
            ((@data[j].values)[1] == t['ccode'])
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
      
      tab_envoi['info'] = @info
      tab_envoi['annees'] = tab_annees #pourraient n'etre envoyes qu'une seule fois
      tab_envoi['pays'] = tab_pays #pourraient n'etre envoyes qu'une seule fois
      tab_envoi['data'] = tab_do

      outfile = File.new("#{RAILS_ROOT}/public/json/data#{@dataset.id}_#{@variable.var_id}.json", "w")
      outfile.puts tab_envoi.to_json
      outfile.close
    end # fin de la boucle 'variable'
        
        
        
      # Check to see if it exists    
#      if File.exists?("#{RAILS_ROOT}/public/#{folder}")
#        puts "#{RAILS_ROOT}/public/#{folder} exists"
#      else
#        puts "#{RAILS_ROOT}/public/#{folder} doesn't exist so we're creating"
#        Dir.mkdir "#{RAILS_ROOT}/public/#{folder}"
#      end
#         
#    end
  end
end