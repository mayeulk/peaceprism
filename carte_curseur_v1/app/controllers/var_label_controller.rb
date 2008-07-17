class VarLabelController < ApplicationController
  def show
      #@var_label = VarLabel.find(4)
      #TODO: faire que ca marche pour les autres variables que 13 (xrreg)
      @var_label = VarLabel.find(:first, :conditions => 'value = \''+params[:id]+'\' and var_id=13')
       
      #@var_label = VarLabel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @var_label }
    end
  end

  # map.connect 'var_label/:dataset_id/:variable_id/:value', :controller => 'var_label', :action => 'show_description'
  def show_description
    @var_label = VarLabel.find(:first, :conditions => 'value = \''+params[:value]+'\' and var_id = \''+params[:variable_id]+'\' and dataset_id = \'' +params[:dataset_id]+'\'')
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @var_label }
    end
  end
  

end
