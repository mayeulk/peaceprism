class AddColumnsToDatasets < ActiveRecord::Migration
  def self.up
    add_column(:datasets, :identifierccode1_var, :integer) #contient le numéro (2 ou 3 ou 4 ou...) de la colonne de la table "dataset_1" (par exemple) qui contient la variable "identifierccode1" 
    add_column(:datasets, :identifierccode2_var, :integer)
    add_column(:datasets, :identifieryear_var, :integer)
  end

  def self.down
     remove_column(:datasets, :identifierccode1_var)
     remove_column(:datasets, :identifierccode2_var)
     remove_column(:datasets, :identifieryear_var)
  end
end
