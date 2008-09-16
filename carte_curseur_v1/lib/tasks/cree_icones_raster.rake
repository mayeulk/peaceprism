# usage: rake "db:create_raster_icons[xx]"
# avec xx la plus grande dimension (hauteur/largeur) voulue
require 'find' 
namespace :db do
  desc "Cree les icones raster a partir de svg"
  task(:create_raster_icons, :taille) do |t, args|
    p "#{RAILS_ROOT}/icons/"
    
    @svgfiles = Array.new
    Find.find("#{RAILS_ROOT}/icons/") do |path|
      # fichiers se terminant par ".svg"
      if File.basename(path) =~ /\.svg$/  
        @svgfiles = @svgfiles << File.basename(path, ".svg")
      end
    end



taille=args[:taille]

if taille.to_i.to_s == taille.to_s
  @svgfiles.each do |f|
    puts "#############################################################"
    thread = Thread.new { `inkscape -z --query-height -f ./icons/#{f}.svg` }
    hauteur=thread.value.to_i
    thread = Thread.new { `inkscape -z --query-width -f ./icons/#{f}.svg` }
    largeur=thread.value.to_i
    
    if hauteur >= largeur
      thread =  Thread.new { `inkscape -z --export-height=#{taille} -e #{RAILS_ROOT}/public/images/icones/#{f}-#{taille}.png -f #{RAILS_ROOT}/icons/#{f}.svg`}
      puts "Portrait: " +  hauteur.to_s + " " +  largeur.to_s
      puts thread.value
      
    else
      thread =  Thread.new { `inkscape -z --export-width=#{taille} -e #{RAILS_ROOT}/public/images/icones/#{f}-#{taille}.png -f #{RAILS_ROOT}/icons/#{f}.svg`}
      puts "Paysage: " +  hauteur.to_s + " " +  largeur.to_s
      puts thread.value
    end
  end
  
else
  puts "Parametre de taille '#{taille}' incorrect!!!   >:-("
  
 end
    
    
    
  end
end