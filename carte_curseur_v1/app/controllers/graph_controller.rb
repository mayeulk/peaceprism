class GraphController < ApplicationController
  def png
    #require 'R4rb' #mis dans environment.rb
    Array.initR
    'png(filename="/home/mk/PRISM/eclipse_workspace/carte_curseur_v1/public/graphs/essai.png")'.to_R
    ("hist(rnorm("+params[:nb] +"))").to_R
    "dev.off()".to_R
    
#    R4rb.init
#    rvect = R4rb::RVector.new("a")
#    rvect < [1,2,3]
#
#
#      'png(filename="/home/mk/PRISM/eclipse_workspace/carte_curseur_v1/public/graphs/essai.png"'.to_R
#      'plot(a)'.to_R
#      'dev.off()'.to_R
#    
    render :inline => "OK"
  end
end
  