class Variable < ActiveRecord::Base
  belongs_to :dataset, :foreign_key => 'dataset_id'
  validates_presence_of :var_id
  validates_presence_of :dataset_id
  
  validates_existence_of :dataset # valide l'existence d'un dataset associe
end
