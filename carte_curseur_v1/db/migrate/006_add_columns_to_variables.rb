class AddColumnsToVariables < ActiveRecord::Migration
  def self.up
    add_column(:variables, :mini, :float) 
    add_column(:variables, :maxi, :float)
    add_column(:variables, :binary_var, :integer)
    add_column(:variables, :qualitatif_ordonne, :integer)
    
  end

  def self.down
     remove_column(:variables, :mini)
     remove_column(:variables, :maxi)
     remove_column(:variables, :binary_var)
     remove_column(:variables, :qualitatif_ordonne)
  end
end
