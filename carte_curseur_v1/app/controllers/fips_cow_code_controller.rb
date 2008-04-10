class FipsCowCodeController < ApplicationController
  def import
    @fips_cow_file='/home/commun/ecole/REC/PRISM/programmation_PRISM/SIG/diamonds_country_codes.csv'
    require 'csv'
    
    # lecture des données ligne par ligne
    CSV::Reader.parse(File.open(@fips_cow_file), "\t") do |row|
      ligne = FipsCowCode.new
      ligne.country_name = row[0]
      ligne.cowcode = row[1]
      ligne.fips_cntry = row[2]
      ligne.contcode = row[3]
      ligne.save
    end
    
    #essai bidon d'insertion
      ligne = FipsCowCode.new
      ligne.country_name = "DDR"
      ligne.cowcode = 123
      ligne.fips_cntry = "DR"
      ligne.contcode = 2 #code continent
      ligne.save
    
    
    
    
    
    render :text => "OK"
  end
  
end
