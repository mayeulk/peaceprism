# usage: utiliser la console
# cd ~/workspace/carte_curseur_v1
# cd /home/mk/PRISM/eclipse_workspace/carte_curseur_v1/
# rake db:import_yml_data['/home/commun/ecole/REC/PRISM/EUGene/a_importer/','testGuy']

require 'activerecord'
require 'find'

namespace :db do
  desc "Importe les données de type EDF (EUGene) à partir du dossier spécifié"
  task :import_yml_data, :folder, :file, :needs=>:environment do |t, args|  
    args.with_defaults(:folder => '/home/commun/ecole/REC/PRISM/EUGene/a_importer/')
        
    # emplacement du fichier edf
    folder = args[:folder]

    # mantisse du nom du fichiers edf (sans chemin ni .edf)
    yamlfilename = args.file
    
 
        yamlfile=File.open(folder+yamlfilename+".yml","r")
        yaml_data=YAML.load(yamlfile)
        
        @variables=yaml_data.delete("variables")      
        
        @dataset = Dataset.create({"configuration_file" => yamlfilename}.merge(yaml_data))
  
        # nom de la table "dataset_#" contenant les donnees
        @dataset_table="dataset_" + @dataset.id.to_s
        var_n = 1
        ActiveRecord::Base.connection.create_table(@dataset_table, :force => true) do |t|
          @variables.each do |var|
          # cree la colonne 'var1' ou 'var2'... avec le bon type dans la table 'dataset_1'
            case (var[1]) 
              when "string" then t.column("var" + var_n.to_s, :string)
              when "integer" then t.column("var" + var_n.to_s, :integer)
              when "real" then t.column("var" + var_n.to_s, :decimal)
            end
            
            # insère une ligne dans la table 'variables'
            Variable.create({"var_id"=> var_n, "dataset_id" => @dataset.id, "name" => var[0],
              "format" => var[1],"kind" => var[2], "reverse" => var[3],"missing" => var[4]})
              
  
            case var[2] # enregistre le numéro de colonne de ces 3 variables spéciales
              when "identifierccode1" then @dataset.identifierccode1_var = var_n
              when "identifierccode2" then @dataset.identifierccode2_var = var_n
              when "identifieryear" then @dataset.identifieryear_var = var_n
            end
            var_n += 1
          end
          # enregistre dans la table 'datasets' le numéro de colonne des 1 à 3 variables spéciales
          @dataset.save 
        end
        
        
        @tableau_donnees=Array.new
        require 'csv'
        ligne_n = 0
        
        # lecture des données ligne par ligne dans le fichier .csv
        CSV::Reader.parse(File.open(folder + @dataset.data_file_name)) do |row|
          if ligne_n == 0
            # sauter la ligne des titres de colonnes si elle existe
            if @dataset.label_line_in_data_file
              ligne_n = 1
              next
            end
            ligne_n = 1
          end
          
          # une ligne d'un fichier de donnees .csv
          @ligne=Array.new 
          var_n = 0
          
          # écriture des données case par case
          @variables.each do |var| 
            if row[var_n].to_i == var[4].to_i or row[var_n].to_s.gsub(/\.| /,"") == ""
# la valeur est identique à celle qui code les valeurs manquantes ('missing'),
# OU il n'y a rien entre les deux virgules dans le fichier csv, 
# OU il y a une combinaison de point(s) et d'espace(s) 
#(EUGene: 1.Within the input data set, a period (“.”) is treated
# as a missing value code, a blank field is considered missing, 
# and whatever value per variable specified by the user is also
# considered missing.")  
## TODO: cette dernière condition n'est a priori valable que pour les fichiers .edf
              @ligne[var_n] = "NULL" # donc la valeur est NULL
            else
              if var[1] == "string"
                @ligne[var_n] = "'" + row[var_n].to_s + "'"               
              else
                @ligne[var_n] = row[var_n].to_s
              end
            end
            var_n += 1
          end
          ActiveRecord::Base.connection.execute("INSERT INTO " +
            @dataset_table + " VALUES ('" + ligne_n.to_s + "'," +
            @ligne.join(",") + ") ")
          ligne_n += 1
        end
  end

end
