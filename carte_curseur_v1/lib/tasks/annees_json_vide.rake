require 'activerecord' 
namespace :db do
  desc "Cree les fichiers json pour chaque variable"
  task(:create_fichiers_json_vide => :environment) do

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

     
    # recueil des donnees concernant la variable (pour le type de discretisation)
    @info = Hash.new()
    @info['var_id'] = 0
    @info['dataset_id'] = 0
    @info['name'] = 'empty'
    @info['format'] = 'vide'
    @info['type'] = 'vide'
  
        
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
  
    outfile = File.new("#{RAILS_ROOT}/public/javascripts/data0_0.js", "w")
    outfile.puts "tab=" + tab_envoi.to_json
    outfile.close
     
  end
end