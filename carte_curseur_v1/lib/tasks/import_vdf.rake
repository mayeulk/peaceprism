# usage: utiliser la console
# cd ~/workspace/carte_curseur_v1
# cd /home/mk/PRISM/eclipse_workspace/carte_curseur_v1/
# rake db:import_vdf_data['/home/commun/ecole/REC/PRISM/EUGene/a_importer/','testGuy']

require 'activerecord'
require 'find'
require 'yaml'


namespace :db do
  desc "Importe les données de type VDF (PRISM) à partir du dossier spécifié"
  task :import_vdf_data, :folder, :file, :needs=>:environment do |t, args|  
    args.with_defaults(:folder => '/home/commun/ecole/REC/PRISM/EUGene/a_importer/')
        
    # emplacement du fichier vdf
    folder = args[:folder]

    # mantisse du nom du fichiers vdf (sans chemin ni .edf)
    @vdffilename = args.file
    
    # recuperation de l'id du dataset parent (necessaire dans var_Label)
    @dataset_id = ActiveRecord::Base.connection.select_value(
      "Select id from datasets where configuration_file = '#{@vdffilename}'")

    # ouverture du fichier vdf et chargement du contenu en yaml
    require('yaml')
    vdf_file=File.open(folder+@vdffilename+".vdf","r")
    vdf_data=YAML.load(vdf_file)
    
    @variables=vdf_data["variable"]  
    @var_labels=vdf_data["var_label"]  

    vdf_file.close
    
    # insere les donnees dans la table des variables (par ecrasement) 
    @variables.each do |var|
      #var = vari.to_hash
      puts(var)
      @var_id = ActiveRecord::Base.connection.select_value(
      "Select id from variables where dataset_id = #{@dataset_id} and var_id = #{var['var_id']}")

      Variable.update(@var_id, var)
    end

    @var_labels.each do |lab|
      @label = VarLabel.create(lab)
      VarLabel.update(@label.id, {"dataset_id" => @dataset_id})
              
#      ActiveRecord::Base.connection.execute("UPDATE variables set" +
#            @dataset_table + " VALUES ('" + ligne_n.to_s + "'," +
#            @ligne.join(",") + ") ")  
        
    end
  end

end