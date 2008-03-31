class DatasetsController < ApplicationController
  before_filter(:load_researchers, :only =>[:show, :edit])
  
  def load_researchers
    @dataset = Dataset.find(params[:id])
    @researchers = @dataset.researchers
    @all_researchers = Researcher.find(:all, :order => "name ASC")
  end
  
  def importcsv
    require 'csv'
    @repertoire = '/home/commun/ecole/REC/OTAN/Eck-database/'
    @parsed_file = CSV::Reader.parse(File.open(@repertoire + 'eckconflict-base.csv'))
    @premiere_ligne = true
    @parsed_file.each do |row|
      if @premiere_ligne == true # la premiere ligne contient les noms de colonne
        @premiere_ligne = false
      else
        d=Dataset.new
        d.id=row[0]
        d.baseid_pb=row[1]
        d.name=row[2]
        d.description=row[3]
        d.temporaldomain=row[4]
        d.spatialdomain=row[5]
        d.typeofevent=row[6]
        d.definitionofevent=row[7]
        d.violencethreshold=row[8]
        d.datacoded=row[9]
        d.principalresearcher=row[10]
        d.accesstoinformation=row[11]
        d.url=row[12]
        d.recherche_commencee=row[13]
        d.recherche_finie=row[14]
        d.manque_info_importantes=row[15]
        d.debut=row[16]
        d.fin=row[17]
        d.save
      end
    end
  redirect_to(:controller => 'researchers', :action => 'importcsv')
  #render(:text => "Importation OK", :layout => true)
  end
  
  # GET /datasets
  # GET /datasets.xml
  def index
    @datasets = Dataset.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @datasets }
    end
  end

  # GET /datasets/1
  # GET /datasets/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dataset }
    end
  end

  # GET /datasets/new
  # GET /datasets/new.xml
  def new
    @dataset = Dataset.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dataset }
    end
  end

  # GET /datasets/1/edit
  def edit
  end

  # POST /datasets
  # POST /datasets.xml
  def create
    @dataset = Dataset.new(params[:dataset])

    respond_to do |format|
      if @dataset.save
        flash[:notice] = 'Dataset was successfully created.'
        format.html { redirect_to(@dataset) }
        format.xml  { render :xml => @dataset, :status => :created, :location => @dataset }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dataset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /datasets/1
  # PUT /datasets/1.xml
  def update
    @dataset = Dataset.find(params[:id])

    respond_to do |format|
      if @dataset.update_attributes(params[:dataset])
        flash[:notice] = 'Dataset was successfully updated.'
        format.html { redirect_to(@dataset) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dataset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /datasets/1
  # DELETE /datasets/1.xml
  def destroy
    @dataset = Dataset.find(params[:id])
    @dataset.destroy

    respond_to do |format|
      format.html { redirect_to(datasets_url) }
      format.xml  { head :ok }
    end
  end
end
