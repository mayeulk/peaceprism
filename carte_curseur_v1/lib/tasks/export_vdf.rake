# export dataset in YAML(description) and CSV(data) format

require 'activerecord'
require 'find'

namespace :db do
  desc "Exporte un jeu de données (sauvegarde) en format YaML et CSV"
  task :export_dataset, :id, :needs=>:environment do |t, args|  
    #args.with_defaults(:folder => '/home/commun/ecole/REC/PRISM/EUGene/a_importer/')
        
    @dataset_choisi = args[:id]
     
      # le partiel rendu contiendra la description du dataset et la confirmation de sauvegarde
      #@citation = ActiveRecord::Base.connection.select_value(
      #"Select data_set_citation from datasets where id = #{@dataset_choisi}")
      #@information = "dataset saved"
      
      # recuperation du nom de fichier (=nom du fichier edf)
      @vdffile_name = ActiveRecord::Base.connection.select_value(
      "Select configuration_file from datasets where id = #{@dataset_choisi}")
      
      # selection des variables du dataset
      # pour chaque variable, un sous-hash des valeurs qualitatives speciales
      @vdf=Hash.new
      @vdf['variable'] = Variable.find(:all, :order => "var_id ASC", :conditions => "dataset_id = #{@dataset_choisi}")
      @vdf['var_label'] = VarLabel.find(:all,  :conditions => "dataset_id = #{@dataset_choisi}")
      
      vdffile=File.open("#{RAILS_ROOT}/db/data_backups/"+@vdffile_name+".vdf","w")
#      vdffile=File.open('/home/gtokarski/workspace/carte_curseur_v1/db/data_backups/essai.vdf',"w")
      vdffile.write(@vdf.to_yaml)
      vdffile.close
   
      #vdffile=File.open("#{RAILS_ROOT}/db/data_backups/"+@vdffile_name+".vdf","r")
      #@essai=vdffile.read
      #vdffile.close
            #essai2=YAML.load_file("#{RAILS_ROOT}/db/data_backups/"+@vdffile_name+".vdf")
      #render :partial => "create_vdf"
  end
end