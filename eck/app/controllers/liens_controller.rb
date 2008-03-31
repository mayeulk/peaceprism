class LiensController < ApplicationController

  def importcsv
    require 'csv'
    @repertoire = '/home/commun/ecole/REC/OTAN/Eck-database/'
    @parsed_file = CSV::Reader.parse(File.open(@repertoire + 'eckconflict-liens.csv'))
    @premiere_ligne = true
    @parsed_file.each do |row|
      if @premiere_ligne == true # la premiere ligne contient les noms de colonne
        @premiere_ligne = false
      else
        d=Lien.new
        d.dataset_id=row[0]
        d.baseid_pb=row[1]
        d.researcher_id=row[2]
        d.save
      end
    end    
  render(:inline => "Importation OK", :layout => false)
  end


  
  
  # GET /liens
  # GET /liens.xml
  def index
    @dataset_researchers = Lien.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dataset_researchers }
    end
  end

  # GET /liens/1
  # GET /liens/1.xml
  def show
    @lien = Lien.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @lien }
    end
  end

  # GET /liens/new
  # GET /liens/new.xml
  def new
    @lien = Lien.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @lien }
    end
  end

  # GET /liens/1/edit
  def edit
    @lien = Lien.find(params[:id])
  end

  # POST /liens
  # POST /liens.xml
  def create
    @lien = Lien.new(params[:lien])

    respond_to do |format|
      if @lien.save
        flash[:notice] = 'Lien was successfully created.'
        format.html { redirect_to(@lien) }
        format.xml  { render :xml => @lien, :status => :created, :location => @lien }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @lien.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /liens/1
  # PUT /liens/1.xml
  def update
    @lien = Lien.find(params[:id])

    respond_to do |format|
      if @lien.update_attributes(params[:lien])
        flash[:notice] = 'Lien was successfully updated.'
        format.html { redirect_to(@lien) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @lien.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /liens/1
  # DELETE /liens/1.xml
  def destroy
    @lien = Lien.find(params[:id])
    @lien.destroy

    respond_to do |format|
      format.html { redirect_to(liens_url) }
      format.xml  { head :ok }
    end
  end
end
