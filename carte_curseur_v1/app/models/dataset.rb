class Dataset < ActiveRecord::Base
  has_many :variables
  #validates_presence_of :id
end
