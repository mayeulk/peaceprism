require 'rake'
require 'tasks/rails'
require 'find'

 namespace :db do
  desc "Importe les données de tous les fichiers type EDF (EUGene) à partir du dossier spécifié"
  task :import_all_edf_data, :folder, :needs=>:environment do |t, args|  
 
 @folder=args.folder
 
 # liste les fichiers .edf
    @edffiles = Array.new
    Find.find(@folder) do |path|
     # fichiers se terminant par ".edf"
      if File.basename(path) =~ /\.edf$/  
        @edffiles = @edffiles << File.basename(path, ".edf")
      end
    end
#Rake.run(db:import_edf_data['/home/commun/ecole/REC/PRISM/EUGene/a_importer/','testGuy'])
@edffiles.each do |edffile|
 # enlever les diezes des 3 lignes suivantes pour tester sur un seul fichier, tesGuy.edf
 if edffile=="testGuy" then
  Rake.application.invoke_task("db:import_edf_data["+@folder+","+edffile+"]")
 end

end


  end
end