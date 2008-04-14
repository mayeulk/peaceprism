class FipsCowCodeController < ApplicationController
  def import
    FipsCowCode.delete_all
    
    @fips_cow_file=RAILS_ROOT + '/db/diamonds_country_codes.csv'
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
    

    
    
    
    
    render :text => "OK"
  end
  
end
