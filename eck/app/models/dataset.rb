class Dataset < ActiveRecord::Base
  has_many :dataset_researchers
  has_many :researchers, :through => :dataset_researchers
end
