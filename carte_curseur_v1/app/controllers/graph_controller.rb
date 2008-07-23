class GraphController < ApplicationController

#def gestioncache
#  @file = "hist" + params[:dataset_id] + "-" + params[:variable_id] + ".svg"
#  @filepath = "/home/mk/PRISM/eclipse_workspace/carte_curseur_v1/public/graphs/" + @file
#  if  file.exists?(@filepath)
#    send_file(@filepath, :filename => @file, :type => 'image/svg+xml',
#      :disposition => 'inline', :stream=> false)
#  end
#end


  # graph de distribution (histogramme ou diagramme en barre)
  # tous pays, toutes annees, 1 variable
  def dis

# TODO: a factoriser pour ne pas le repeter lorsqu'on ajoutera d'autres types de graphiques
#    gestioncache()

  # nom du fichier a ecrire
  @file = "hist" + params[:dataset_id] + "-" + params[:variable_id] + ".svg"
  
  #nom du fichier avec le chemin complet (TODO: le faire a partir de la racine de l'application rails)
  @filepath = "/home/mk/PRISM/eclipse_workspace/carte_curseur_v1/public/graphs/" + @file
  if  !File.exists?(@filepath)
   
    @dataset = Dataset.find(params[:dataset_id])
    @variable = Variable.find(:first, :conditions => "var_id = #{params[:variable_id]} AND dataset_id = #{params[:dataset_id]}")
  
    # Solution 1
    #avantages: Completed in 0.58950 (1 reqs/sec) | Rendering: 0.00009 (0%) | DB: 0.09065 (15%) | 200 OK [http://192.168.1.18/data/6/col/13/png]
    #1- les requetes sql peuvent etre mises en caches (surtout pays et annees, identiques pour toutes les variables d'un jeu de donnees)
    #2- on n'est pas oblige de faire les traitements
    @pays = ActiveRecord::Base.connection.select_values("SELECT var#{@dataset.identifierccode1_var}
      from dataset_#{@dataset.id} order by id")
    @annees = ActiveRecord::Base.connection.select_values("SELECT var#{@dataset.identifieryear_var}
      from dataset_#{@dataset.id} order by id")
    # type string car le gem R4rb ne gere pas les nil (mais gere "")
    @data = ActiveRecord::Base.connection.select_values(" SELECT CASE WHEN var#{@variable.var_id} IS NOT NULL THEN var#{@variable.var_id}::varchar  ELSE '' END FROM dataset_#{@dataset.id} order by id")


    #  Solution 2 : Completed in 0.68566 (1 reqs/sec) | Rendering: 0.00009 (0%) | DB: 0.07486 (10%) | 200 OK [http://192.168.1.18/data/6/col/13/png]
    #  @full_data = ActiveRecord::Base.connection.select_all("SELECT var#{@dataset.identifierccode1_var} as ccode, var#{@dataset.identifieryear_var} as annee, var#{@variable.var_id} as data from dataset_#{@dataset.id} where var#{@variable.var_id} IS NOT NULL")
    #  @full_data = (@full_data.collect {|x| x.values}).transpose
    #  @pays=  @full_data[0]
    #  @annees=  @full_data[1]
    #  @data =  @full_data[2]

    # require 'R4rb' #mis dans environment.rb
    # initialise certaines fonctionnalites du gem  R4rb de Remy Drouilhet
    Array.initR
#   "library(RSvgDevice)".to_R #deja appele par ce qui suit
    "library(RSVGTipsDevice,lib.loc='/usr/local/lib64/R/library/')".to_R #chemin important, sinon on charge une ancienne librairie, qui bogue (cf. http://cran.r-project.org/web/packages/RSVGTipsDevice/NEWS cf. Rf_str2col)
    @dataset.data_set_full_name.to_a > :data_set_full_name
    @variable.name.to_a > :variable_name
    #@variable.long_name.to_a > :variable_long_name
    
    #transfere les donnes de ruby a R
    @data > :data
    ('devSVGTips(file="' + @filepath + '", toolTipMode = 2, toolTipOpacity=.85)').to_R
    ##TODO: a utiliser pour IE?
    #('png(filename="' + @filepath + '")').to_R
    #'hist(x=as.numeric(data), main=variable_name, sub=data_set_full_name,xlab=variable_name)'.to_R
    
    #definit des marges bas et droite plus importantes (sinon certains tooltips tronques)
    "par(mar=c(7, 4, 4, 10) + 0.1)".to_R 

    # La variable contient au moins une partie qualitative (cf. description qualitative dans la base de donnees, ou nombre de valeurs differentes inferieure a 26. Cf. certaines variables de polity)
    @qualit = VarLabel.exists?(:dataset_id => @dataset.id, :var_id => @variable.var_id) | (@data.uniq.length < 26)
    
    #variable qualitative
    if @qualit
      # 'barplot(table(as.numeric(data)), main=variable_name, sub=data_set_full_name,
      # xlab=variable_name)'.to_R
      R4rb.eval <<-CodeR
        table.data<-table(as.numeric(data))
        total<-sum(table.data)
        a<-barplot(table.data, main=variable_name, sub=data_set_full_name,xlab=variable_name, space=.9)
         for (box in 1:length(table.data)) {
          setSVGShapeToolTip(title=paste("x =",names(table.data[box])),desc1=paste("n = ",table.data[box]),
          desc2=paste(round((table.data[box]/total*100),1),"% of total "))
          rect(a[box]-.5,0,a[box]+.5,table.data[box], col='lightgray')
         } 
      CodeR
          
    else #variable "continue"
      #'hist(as.numeric(data), main=variable_name, sub=data_set_full_name)'.to_R
      R4rb.eval <<-CodeR
        data<-as.numeric(data)
        # TODO: ne marche pas avec len=11 (deciles) pour la varialbe polity/durable. A creuser. Pas de bug sous R interactif avec rnorm(100)
        # TODO: regarder l'option 'type' dans la fonction quantile de R
        a<-hist(data, breaks=quantile(data, probs=seq(0,1,len=9),na.rm=T,names=F),
          main=variable_name, sub=data_set_full_name)
        total<-sum(a$counts)
        for (box in 1:length(a$counts)) {
          setSVGShapeToolTip(title=paste("x ∈",ifelse(box==1,"[","]"),
          a$breaks[box],";",a$breaks[box+1],"]"),
            desc1=paste("n =",a$counts[box]),
           desc2=paste(round(a$counts[box]*100/total,1),"% of total ")
           #desc2=paste(round((a$density[box]*100*(a$breaks[box+1]-a$breaks[box])),1),"% of total ")
         )
          rect(a$breaks[box],0,a$breaks[box+1],a$density[box], col='lightgray')
        }
      CodeR
      end
      
      'dev.off()'.to_R #ferme le device, donc ecrit le fichier graphique
    end

    #envoie le fichier (pas de vue rendue)
    send_file(@filepath, :filename => @file, :type => 'image/svg+xml',
      :disposition => 'inline', :stream=> false)

  end


end
  