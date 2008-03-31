class DatasetResearchersController < ApplicationController
  def importcsv
    require 'csv'
    @repertoire = '/home/commun/ecole/REC/OTAN/Eck-database/'
    @parsed_file = CSV::Reader.parse(File.open(@repertoire + 'eckconflict-liens.csv'))
    @premiere_ligne = true
    @parsed_file.each do |row|
      if @premiere_ligne == true # la premiere ligne contient les noms de colonne
        @premiere_ligne = false
      else
        d=DatasetResearcher.new
        d.dataset_id=row[0]
        d.baseid_pb=row[1]
        d.researcher_id=row[2]
        d.save
      end
    end    
    render(:inline => "Importation OK", :layout => false)
  end


  
  
  # GET /dataset_researchers
  # GET /dataset_researchers.xml
  def index
    @dataset_researchers = DatasetResearcher.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dataset_researchers }
    end
  end

  # GET /dataset_researchers/1
  # GET /dataset_researchers/1.xml
  def show
    @dataset_researcher = DatasetResearcher.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dataset_researcher }
    end
  end

  # GET /dataset_researchers/new
  # GET /dataset_researchers/new.xml
  def new
    @dataset_researcher = DatasetResearcher.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dataset_researcher }
    end
  end

  # GET /dataset_researchers/1/edit
  def edit
    @dataset_researcher = DatasetResearcher.find(params[:id])
  end

  # POST /dataset_researchers
  # POST /dataset_researchers.xml
  def create
    @dataset_researcher = DatasetResearcher.new(params[:dataset_researcher])

    respond_to do |format|
      if @dataset_researcher.save
        flash[:notice] = 'DatasetResearcher was successfully created.'
        format.html { redirect_to(@dataset_researcher) }
        format.xml  { render :xml => @dataset_researcher, :status => :created, :location => @dataset_researcher }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dataset_researcher.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dataset_researchers/1
  # PUT /dataset_researchers/1.xml
  def update
    @dataset_researcher = DatasetResearcher.find(params[:id])

    respond_to do |format|
      if @dataset_researcher.update_attributes(params[:dataset_researcher])
        flash[:notice] = 'DatasetResearcher was successfully updated.'
        format.html { redirect_to(@dataset_researcher) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dataset_researcher.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dataset_researchers/1
  # DELETE /dataset_researchers/1.xml
  def destroy
    @dataset_researcher = DatasetResearcher.find(params[:id])
    @dataset_researcher.destroy

    respond_to do |format|
      format.html { redirect_to(dataset_researchers_url) }
      format.xml  { head :ok }
    end
  end
  
  def update_related_researchers
    DatasetResearcher.delete_all(["dataset_id = ?", params[:dataset_id]])
    if params[:researcher_ids]
      for researcher_id in params[:researcher_ids]
        DatasetResearcher.create(:dataset_id => params[:dataset_id], :researcher_id => researcher_id)
      end
    end
    redirect_to(:back)
  end
  
end
