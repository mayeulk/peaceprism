class DataController < ApplicationController
  
  #  map.connect 'data/:dataset_id/:variable_id/:row_id', :controller => 'data', :action => 'show_value'
  # un pays, une annee, une variable d'un jeu de donnees
  def show_value 
    @dataset = Dataset.find(params[:dataset_id])
    @variable = Variable.find(params[:variable_id])
    if params[:row_id].gsub(/[0-9]/,"").length == 0 #il n'y a que des chiffres
      @data = ActiveRecord::Base.connection.select_value("SELECT var#{@variable.var_id} from dataset_#{@dataset.id} WHERE  id = #{params[:row_id]} ORDER BY id ASC")
      render :inline =>    @data.to_json  
    else
      render :text => 'Invalid parameters'
    end
  end

  # un pays, une annee, toutes variables d'un jeu de donnees
  #  map.connect 'data/:dataset_id/row/:row_id', :controller => 'data', :action => 'show_row'
  def show_row
    @dataset = Dataset.find(params[:dataset_id])
    if params[:row_id].gsub(/[0-9]/,"").length == 0 #il n'y a que des chiffres
      @data = ActiveRecord::Base.connection.select_one("SELECT * from dataset_#{@dataset.id} WHERE  id = #{params[:row_id]} LIMIT 1")
      render :inline =>    @data.to_json  
    else
      render :text => 'Invalid parameters'
    end
  end

  # tous pays, toutes annees, une variable d'un jeu de donnees
  # map.connect 'data/:dataset_id/col/:variable_id', :controller => 'data', :action => 'show_column'
  # http://localhost:3000/data/1/col/8
  def show_column
#    @dataset = Dataset.find(params[:dataset_id])
#    @variable = Variable.find(params[:variable_id])
#    @data = ActiveRecord::Base.connection.select_values("SELECT var#{@variable.var_id} from dataset_#{@dataset.id} ORDER BY id ASC")
#    render :inline =>    @data.to_json
    @dataset = Dataset.find(params[:dataset_id])
    @variable = Variable.find(params[:variable_id])
    @data = ActiveRecord::Base.connection.select_all("SELECT var#{@dataset.identifierccode1_var} as ccode, var#{@dataset.identifieryear_var} as year, var#{@variable.var_id} as data from dataset_#{@dataset.id} ORDER BY var#{@dataset.identifierccode1_var} , var#{@dataset.identifieryear_var} ")
#    @data = ActiveRecord::Base.connection.select_all("SELECT var#{@dataset.identifierccode1_var} as ccode, var#{@dataset.identifieryear_var} as year, var#{@variable.var_id} as data from dataset_#{@dataset.id}, fip ORDER BY var#{@dataset.identifierccode1_var} , var#{@dataset.identifieryear_var} ")
    @pays = ActiveRecord::Base.connection.select_values("SELECT var#{@dataset.identifierccode1_var} as ccode from dataset_#{@dataset.id} group by var#{@dataset.identifierccode1_var} ORDER BY var#{@dataset.identifierccode1_var} ASC")
    @annees = ActiveRecord::Base.connection.select_values("SELECT var#{@dataset.identifieryear_var} as annee from dataset_#{@dataset.id} group by var#{@dataset.identifieryear_var} ORDER BY var#{@dataset.identifieryear_var} ASC")
    @tableau = Array.new
    for annee in @annees
      @tableau[annee.to_i] = Hash.new()
      @pays.each do |pays|
        @tableau[annee.to_i][pays.to_i] = "#"
      end
    end
    
    for ligne in @data # pour chaque ligne (annee-pays) du tableau de donnees
#      @tableau << [ligne['year'], ligne['ccode'], ligne['data']]
      @tableau[ligne['year'].to_i][ligne['ccode'].to_i] = case when ligne['data'] == nil then nil else ligne['data'].to_f end
#      @tableau[ligne['year'].to_i] = ligne['data']
    end
#    render :inline =>    @data.to_json
    render :inline =>    @tableau[1870..2003].to_json + @annees.to_json
#    render :inline =>    @annees.to_json
  end


  # tous pays, toutes annees, toutes variables d'un jeu de donnees
  #  map.connect 'data/:dataset_id', :controller => 'data', :action => 'show_dataset'
  def show_dataset
    @dataset = Dataset.find(params[:dataset_id])
    @data = (ActiveRecord::Base.connection.select_all("SELECT * from dataset_#{@dataset.id} ORDER BY id ASC")).to_json
    render :inline =>    @data
  end

end
