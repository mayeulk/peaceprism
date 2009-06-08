class ExportController < ApplicationController

#  before_filter :initialise_var
  # initialise les variables ruby au chargement de la page
#  def initialise_var
#  end
  
  def create_vdf
    @dataset_choisi = params[:datas]
    if @dataset_choisi != '0'
      
      # le partiel rendu contiendra la description du dataset et la confirmation de sauvegarde
      @citation = ActiveRecord::Base.connection.select_value(
      "Select data_set_citation from datasets where id = #{@dataset_choisi}")
      @information = "dataset saved"
      
      # recuperation du nom de fichier (=nom du fichier edf)
      @vdffile_name = ActiveRecord::Base.connection.select_value(
      "Select configuration_file from datasets where id = #{@dataset_choisi}")
      
      # selection des variables du dataset
      # pour chaque variable, un sous-hash des valeurs qualitatives speciales
      @vdf=Hash.new
      @vdf['variable'] = Variable.find(:all, :order => "var_id ASC", :conditions => "dataset_id = #{@dataset_choisi}")
      @vdf['var_label'] = VarLabel.find(:all,  :conditions => "dataset_id = #{@dataset_choisi}")
      
        vdffile=File.open("#{RAILS_ROOT}/db/data_backups/"+@vdffile_name+".vdf","w")
#        vdffile=File.open('/home/gtokarski/workspace/carte_curseur_v1/db/data_backups/essai.vdf',"w")
        vdffile.write(@vdf.to_yaml)
        vdffile.close
   
        vdffile=File.open("#{RAILS_ROOT}/db/data_backups/"+@vdffile_name+".vdf","r")
        @essai=vdffile.read
        vdffile.close
            essai2=YAML.load_file("#{RAILS_ROOT}/db/data_backups/"+@vdffile_name+".vdf")
      #render :partial => "create_vdf"
      render :inline => '<% puts @essai.inspect %>'
    else        
      render :inline => "OK "
    end
  end
  
  def choose
    #@dataset = Dataset.find(params[:dataset_id])
    #@data = (ActiveRecord::Base.connection.select_all("SELECT * from dataset_#{@dataset.id} ORDER BY id ASC")).to_json
    #render :inline =>    @data
    @dataset_choisi = ""
    @datasets2 = Dataset.find(:all)
    @datasets = ActiveRecord::Base.connection.select_all(
    "Select data_set_full_name, id from datasets order by id")
   
    # la liste des datasets disponibles pour le select html
    @dat = Array.new()
    @dat[0] = ['Please choose a dataset', '0']
    i= 1    
    for @d in @datasets
      option = Array.new()
      option[0] = @d['data_set_full_name']
      option[1] = @d['id']
      @dat[i] = option
      i += 1
    end
   
  end
  
  # http://192.168.1.18:3000/convert/1/xml
  def xml
    @dataset = Dataset.find(params[:dataset_id])
    @data = (ActiveRecord::Base.connection.select_all("SELECT * from dataset_#{@dataset.id} ORDER BY id ASC"))
    render :xml => @data.to_xml
  end
  
end