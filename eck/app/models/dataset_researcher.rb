class DatasetResearcher < ActiveRecord::Base
  belongs_to :dataset
  belongs_to :researcher
end
