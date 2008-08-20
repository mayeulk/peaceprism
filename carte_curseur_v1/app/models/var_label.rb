class VarLabel < ActiveRecord::Base
  belongs_to :variable, :foreign_key => 'var_key'
  validates_presence_of :var_id
  validates_presence_of :dataset_id
  
  validates_existence_of :variable # valide l'existence d'une variable associe
end
