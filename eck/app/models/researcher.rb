class Researcher < ActiveRecord::Base
  has_many :dataset_researchers
  has_many :datasets, :through => :dataset_researchers
end
