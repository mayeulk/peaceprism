# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def rgbo(col,opac)#(r,g,b,opac)
  #fournir [r, g, b] de 0 à 255 et opac(ité) de 0 à 1
  # renvoie une déclaration rgb en css
opac=1-opac
 "rgb("+(col[0]+opac*(255-col[0])).to_i.to_s+","+(col[1]+opac*(255-col[1])).to_i.to_s+","+(col[2]+opac*(255-col[2])).to_i.to_s+")"
#    "rgb("+(col[0]*(1-opac)-255*opac).to_i.to_s+","    +(col[0]*(1-opac)-255*opac).to_i.to_s+","  +(col[0]*(1-opac)-255*opac).to_i.to_s+")"
    # "rgb("+(col[0]*opac).to_i.to_s+","+(col[1]*opac).to_i.to_s+","+(col[2]*opac).to_i.to_s+")"
    #"rgb("+(r*opac).to_i.to_s+","+(g*opac).to_i.to_s+","+(b*opac).to_i.to_s+")"
  end
end
