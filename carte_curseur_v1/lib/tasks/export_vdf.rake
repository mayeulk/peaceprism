# export datasets variables description in vdf format (yaml)

require 'activerecord'
require 'find'

namespace :db do
  desc "Exporte un jeu de données (sauvegarde) en format YaML et CSV"
  task :export_dataset, :id, :needs=>:environment do |t, args|  
    #args.with_defaults(:folder => '/home/commun/ecole/REC/PRISM/EUGene/a_importer/')
        
    @dataset_choisi = args[:id]
      
      # recuperation du nom de fichier (=nom du fichier edf)
      @vdffile_name = ActiveRecord::Base.connection.select_value(
      "Select configuration_file from datasets where id = #{@dataset_choisi}")
      
      # selection des variables du dataset
      # pour chaque variable, un sous-hash des valeurs qualitatives speciales
      @vdf=Hash.new

      @new_liste = Array.new()
      @i= 0

      @liste_variables = Variable.find(:all, :order => "var_id ASC", :conditions => "dataset_id = #{@dataset_choisi}")
      @liste_variables.each do |v|
        #puts(v.inspect)
        if(v.var_id >= 1)
          varr = Hash.new()
          varr['maxi'] = v.maxi
          varr['mini'] = v.mini
          varr['name'] = v.name
          varr['name_fr'] = v.name_fr
          varr['long_name'] = v.long_name
          varr['long_name_fr'] = v.long_name_fr
          varr['code_var'] = v.code_var
          varr['descr_before'] = v.descr_before
          varr['descr_after'] = v.descr_after
          varr['descr_before_fr'] = v.descr_before_fr
          varr['descr_after_fr'] = v.descr_after_fr
          varr['qualitatif_ordonne'] = v.qualitatif_ordonne
          varr['page'] = v.page
          varr['unit'] = v.unit
          varr['unit_fr'] = v.unit_fr
          varr['binary_var'] = v.binary_var
          varr['var_id'] = v.var_id
        end        
        @new_liste[@i] = varr
        @i += 1
      end
      #puts(@new_liste.inspect)
      # @vdf['variable'] = v.to_hash
      #puts(v.to_hash.inspect)
      @liste_var_label = VarLabel.find(:all,  :conditions => "dataset_id = #{@dataset_choisi}")

      @new_liste2 = Array.new()
      @i = 0
      @liste_var_label.each do |v|
        #puts(v.inspect)
        if(v.var_id >= 1)
          varr = Hash.new()
          varr['value'] = v.value
          varr['meaning'] = v.meaning
          varr['meaning_fr'] = v.meaning_fr
          varr['description'] = v.description
          varr['description_fr'] = v.description_fr
          varr['var_id'] = v.var_id
        end        
        @new_liste2[@i] = varr
        @i += 1
      end
      
      @vdf['variable'] = @new_liste
      @vdf['var_label'] = @new_liste2
      #puts(@vdf['variable'].inspect)
      
      vdffile=File.open("#{RAILS_ROOT}/db/data_backups/"+@vdffile_name+"_tmp.vdf","w")
      vdffile.write(@vdf.to_yaml)
      vdffile.close
      # The YAML file produced by to_yaml seems badly formed. See:
      # http://yaml.org/spec/current.html#id2502559
      ## BAD:
      #- long_name_fr:
      #  var_id: 11
      #  mini:
      ## GOOD:
      #-
      #  long_name_fr:
      #  var_id: 11
      #  mini:
      # the following linux system call adds a new line just after the first dash of each array cell
      system("sed 's/^- /-   \\n  /' #{RAILS_ROOT}/db/data_backups/" + @vdffile_name + "_tmp.vdf > #{RAILS_ROOT}/db/data_backups/" + @vdffile_name + ".vdf")
      system("rm #{RAILS_ROOT}/db/data_backups/" + @vdffile_name + "_tmp.vdf")
  end
end