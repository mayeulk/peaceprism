require 'activerecord'

namespace :db do
  desc "Importe les données de type EDF (EUGene) à partir du dossier spécifié. [folder, file], file
  peut-être le nom du fichier une une partie du nom, si vide, alors ce sont
  tous les edf du répertoire"
  task(:import_edf_data2, :folder, :file) do |t, args|  
    args.with_defaults(:folder => '/home/commun/ecole/REC/PRISM/EUGene/a_importer/', :file => nil)
    
    # emplacement des fichiers edf
    @folder=args.folder
    
    require 'find'
        
    # liste les fichiers .edf
    @edffiles = Array.new
    Find.find(@folder) do |path|
      # fichiers se terminant par ".edf"
      if File.basename(path) =~ /\.edf$/
        if args.file.nil?
          @edffiles = @edffiles << File.basename(path, ".edf")
        else
          @edffiles = @edffiles << File.basename(path, ".edf")
        end
      end
    end

    @edffiles.each do |edffile|
      if edffile == "testGuy"
      ################################################################
      
      #@edf_data=edf_to_yaml(@folder, edffile)
      
      ################################################################
      
        require('yaml')
        f1=File.open(@folder+edffile+".edf","r")
        f2=File.open(@folder+edffile+".yml","w")
        first_variable=false
    
        f1.each do |line|
          if first_variable == false
            if line =~ /variable = "/ 
              f2.write("variables:\n")
              first_variable = true
            end
          end
          line=line.gsub("[", '# ').gsub("]",'').gsub(' =',':')
          line=line.gsub(/variable: "(.*),(.*),(.*),(.*),(.*)"/, ' - [\1, \2, \3, \4, \5]')
          line=line.gsub(/"/,"") unless line =~ /data\_set\_citation/
          f2.write(line)
        end
        f1.close
        f2.close
        f2=File.open(@folder+edffile+".yml","r")
        edf_data=YAML.load(f2)
      
      ################################################################
        
        @variables=edf_data.delete("variables")      
        
        #@dataset = Dataset.create({"configuration_file" => edffile}.merge(edf_data) )
  
        @dataset = Dataset.create({"configuration_file" => edffile}.merge(edf_data))
  
        # nom de la table "dataset_#" contenant les donnees
        @dataset_table="dataset_" + @dataset.id.to_s
        var_n = 1
        ActiveRecord::Base.connection.create_table(@dataset_table, :force => true) do |t|
          @variables.each do |var|
            case (var[1]) #en fonction du type, cree la colonne 'var1' ou 'var2'... dans la table 'dataset_1'
              when "string" then t.column("var" + var_n.to_s, :string)
              when "integer" then t.column("var" + var_n.to_s, :integer)
              when "real" then t.column("var" + var_n.to_s, :decimal)
            end
   
            Variable.create({"var_id"=> var_n, "dataset_id" => @dataset.id, "name" => var[0], "format" => var[1],"kind" => var[2], "reverse" => var[3],"missing" => var[4]}) #insère une ligne dans la table 'variables'
  
            case var[2] # enregistre le numéro de colonne de ces 3 variables spéciales
              when "identifierccode1" then @dataset.identifierccode1_var = var_n
              when "identifierccode2" then @dataset.identifierccode1_var = var_n
              when "identifieryear" then @dataset.identifieryear_var = var_n
            end
            var_n += 1
          end
          @dataset.save # enregistre dans la table 'datasets' le numéro de colonne des 1, 2 ou 3 variables spéciales
        end
        
        
        @tableau_donnees=Array.new
        require 'csv'
        ligne_n = 0
        
        # lecture des données ligne par ligne
        CSV::Reader.parse(File.open(@folder + @dataset.data_file_name)) do |row|
          if ligne_n == 0
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
            if row[var_n].to_i == var[4].to_i or row[var_n].to_s.gsub(/\.| /,"") == "" # la valeur est identique à celle qui code les valeurs manquantes ('missing'), OU il n'y a rien entre les deux virgules dans le fichier csv, OU il y a une combinaison de point(s) et d'espace(s) (EUGene: 1.Within the input data set, a period (“.”) is treated as a missing value code, a blank field is considered missing, and whatever value per variable specified by the user is also considered missing.")  
              @ligne[var_n] = "NULL"
            else
              if var[1] == "string"
                @ligne[var_n] = "'" + row[var_n].to_s + "'"               
              else
                @ligne[var_n] = row[var_n].to_s
              end
            end
            var_n += 1
          end
   
          ActiveRecord::Base.connection.execute("INSERT INTO " + @dataset_table + " VALUES ('" + ligne_n.to_s + "'," + @ligne.join(",") + ") ")
          ligne_n += 1
        end       
        
      end
    end
    
    #render(:inline => "ok")
    

  end

end
