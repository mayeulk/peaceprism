class ExportController < ApplicationController
  def choose
    @dataset = Dataset.find(params[:dataset_id])
    #@data = (ActiveRecord::Base.connection.select_all("SELECT * from dataset_#{@dataset.id} ORDER BY id ASC")).to_json
    #render :inline =>    @data
    
  end
  
  # http://192.168.1.18:3000/convert/1/xml
  def xml
    @dataset = Dataset.find(params[:dataset_id])
    @data = (ActiveRecord::Base.connection.select_all("SELECT * from dataset_#{@dataset.id} ORDER BY id ASC"))
    render :xml => @data.to_xml
  end
  
end