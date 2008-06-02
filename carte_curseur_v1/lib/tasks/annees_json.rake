require 'activerecord' 
namespace :db do
  desc "Cree les fichiers json pour chaque variable"
  task(:create_fichiers_json => :environment) do
  

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




  outfile = File.new("#{RAILS_ROOT}/public/json/essai.json", "w")
  outfile.puts tab_envoi.to_json
  outfile.close

        
        
        
        
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