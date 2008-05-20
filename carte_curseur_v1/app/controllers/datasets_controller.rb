class DatasetsController < ApplicationController
  # GET /datasets  ou  GET /datasets.xml
  def index
    @datasets = Dataset.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @datasets }
    end
  end

  # GET /datasets/1  ou  GET /datasets/1.xml
  def show
    @dataset = Dataset.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dataset }
    end
  end

  # GET /datasets/new  ou  GET /datasets/new.xml
  def new
    @dataset = Dataset.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dataset }
    end
  end

  # GET /datasets/1/edit
  def edit
    @dataset = Dataset.find(params[:id])
  end

  # POST /datasets  ou  POST /datasets.xml
  def create
    @dataset = Dataset.new(params[:dataset])

    respond_to do |format|
      if @dataset.save
        flash[:notice] = 'Dataset was successfully created.'
        format.html { redirect_to(@dataset) }
        format.xml  { render :xml => @dataset, :status => :created, :location => @dataset }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dataset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /datasets/1  ou  PUT /datasets/1.xml
  def update
    @dataset = Dataset.find(params[:id])

    respond_to do |format|
      if @dataset.update_attributes(params[:dataset])
        flash[:notice] = 'Dataset was successfully updated.'
        format.html { redirect_to(@dataset) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dataset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /datasets/1  ou  DELETE /datasets/1.xml
  def destroy
    @dataset = Dataset.find(params[:id])
    @dataset.destroy

    respond_to do |format|
      format.html { redirect_to(datasets_url) }
      format.xml  { head :ok }
    end
  end

  def import_all_edf
    # avant d'importer, faire:
    #DB:migrate VERSION=1 
    #DB:migrate VERSION=5
    #supprimer à la main les dataset_1, dataset_2 etc. dans postgres
# cela nécessite d'abord de supprimmer les vues suivantes (ou de faire CASADE DELETE)
#CREATE OR REPLACE VIEW data AS 
# SELECT dataset_1.var2 AS ccode1, world.fips_cntry, (world.fips_cntry::text || world."begin"::text) || world."end"::text AS ccode, dataset_1.var5 AS annee, dataset_1.var8 AS data
#   FROM dataset_1, fips_cow_codes, world
#  WHERE dataset_1.var5 < 2004 AND dataset_1.var2 = fips_cow_codes.cowcode AND fips_cow_codes.fips_cntry::text = world.fips_cntry::text AND dataset_1.var5 >= world."begin" AND dataset_1.var5 <= world."end"
#  ORDER BY dataset_1.var5, (world.fips_cntry::text || world."begin"::text) || world."end"::text;
#ALTER TABLE data OWNER TO postgres;
#
#CREATE OR REPLACE VIEW tab AS 
# SELECT DISTINCT annees.annee, world.fips_cntry, (world.fips_cntry::text || world."begin"::text) || world."end"::text AS ccode, world."begin", world."end"
#   FROM annees, world
#  WHERE annees.annee >= (( SELECT min(dataset_1.var5) AS min
#           FROM dataset_1)) AND annees.annee <= (( SELECT max(dataset_1.var5) AS max
#           FROM dataset_1))
#  ORDER BY annees.annee, (world.fips_cntry::text || world."begin"::text) || world."end"::text, world.fips_cntry, world."begin", world."end";
#ALTER TABLE tab OWNER TO postgres;
    #http://localhost:3000/datasets/import_all_edf
#recréer les vues
    # emplacement des fichiers edf
    @folder='/home/commun/ecole/REC/PRISM/EUGene/a_importer/'
    require 'find'
    
    # liste les fichiers .edf
    @edffiles = Array.new
    Find.find(@folder) do |path|
      # fichiers se terminant par ".edf"
      if File.basename(path) =~ /\.edf$/  
        @edffiles = @edffiles << File.basename(path, ".edf")
      end
    end

    @edffiles.each do |edffile|
      @edf_data=edf_to_yaml(@folder, edffile)
      @variables=@edf_data.delete("variables")
      @dataset = Dataset.create({"configuration_file" => edffile}.merge(@edf_data) )
      
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
    
    render(:inline => "ok")
    

  end

  def edf_to_yaml(folder, filename)
    require('yaml')
    f1=File.open(folder+filename+".edf","r")
    f2=File.open(folder+filename+".yml","w")
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
    f2=File.open(folder+filename+".yml","r")
    edf_data=YAML.load(f2)
    return edf_data
  end

end
