class ResearchersController < ApplicationController
  def importcsv
    require 'csv'
    @repertoire = '/home/commun/ecole/REC/OTAN/Eck-database/'
    @parsed_file = CSV::Reader.parse(File.open(@repertoire + 'eckconflict-chercheurs.csv'))
    @premiere_ligne = true
    @parsed_file.each do |row|
      if @premiere_ligne == true # la premiere ligne contient les noms de colonne
        @premiere_ligne = false
      else
        d=Researcher.new
        d.id=row[0]
        d.name=row[1]
        d.first_name=row[2]
        d.email=row[3]
        d.comment=row[4]
        d.save
      end
    end
  
    redirect_to(:controller => 'dataset_researchers', :action => 'importcsv')
  end
  
  # GET /researchers
  # GET /researchers.xml
  def index
    @researchers = Researcher.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @researchers }
    end
  end

  # GET /researchers/1
  # GET /researchers/1.xml
  def show
    @researcher = Researcher.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @researcher }
    end
  end

  # GET /researchers/new
  # GET /researchers/new.xml
  def new
    @researcher = Researcher.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @researcher }
    end
  end

  # GET /researchers/1/edit
  def edit
    @researcher = Researcher.find(params[:id])
  end

  # POST /researchers
  # POST /researchers.xml
  def create
    @researcher = Researcher.new(params[:researcher])

    respond_to do |format|
      if @researcher.save
        flash[:notice] = 'Researcher was successfully created.'
        format.html { redirect_to(@researcher) }
        format.xml  { render :xml => @researcher, :status => :created, :location => @researcher }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @researcher.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /researchers/1
  # PUT /researchers/1.xml
  def update
    @researcher = Researcher.find(params[:id])

    respond_to do |format|
      if @researcher.update_attributes(params[:researcher])
        flash[:notice] = 'Researcher was successfully updated.'
        format.html { redirect_to(@researcher) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @researcher.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /researchers/1
  # DELETE /researchers/1.xml
  def destroy
    @researcher = Researcher.find(params[:id])
    @researcher.destroy
    DatasetResearcher.delete_all(["researcher_id = ?",params[:id]])
    respond_to do |format|
      format.html { redirect_to(researchers_url) }
      format.xml  { head :ok }
    end
  end
end
