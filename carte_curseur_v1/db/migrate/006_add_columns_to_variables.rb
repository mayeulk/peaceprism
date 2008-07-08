class AddColumnsToVariables < ActiveRecord::Migration
  def self.up
    add_column(:variables, :mini, :float) 
    add_column(:variables, :maxi, :float)
    add_column(:variables, :binary_var, :integer)
    add_column(:variables, :qualitatif_ordonne, :integer)
    
  end

  def self.down
     remove_column(:variables, :identifierccode1_var)
     remove_column(:variables, :identifierccode2_var)
     remove_column(:variables, :identifieryear_var)
     remove_column(:variables, :qualitatif_ordonne)
  end
end
