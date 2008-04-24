class FipsCowCodeController < ApplicationController
  # importe le fichier '/db/diamonds_country_codes.csv' dans la table SQL 'fips_cow_codes'
  def import
    FipsCowCode.delete_all #supprimme toutes les lignes existantes
    
    @fips_cow_file=RAILS_ROOT + '/db/diamonds_country_codes.csv'
    require 'csv'
    
    # lecture des donnees ligne par ligne
    CSV::Reader.parse(File.open(@fips_cow_file), "\t") do |row|
      ligne = FipsCowCode.new
      ligne.country_name = row[0]
      ligne.cowcode = row[1]
      ligne.fips_cntry = row[2]
      ligne.contcode = row[3]
      ligne.save #enregistre la ligne dans la table SQL
    end
    
    render :text => "OK"
  end
  
end
