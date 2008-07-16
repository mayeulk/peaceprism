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
end
