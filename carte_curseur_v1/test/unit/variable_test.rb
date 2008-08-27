require File.dirname(__FILE__) + '/../test_helper'

fixtures :variables, :datasets

class VariableTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_should_create_record
    variable = Variable.create(:var_id=>5, :dataset_id=>1)
    assert variable.valid?, "variable non valide"
  end
  
  
#  def test_should_not_create_duplicate_record
#    variable = Variable.create(:var_id=>6, :dataset_id=>1)
#    assert variable.valid?, "variable non valide"
#  end
  
   def test_should_not_create_orphan_record
    variable = Variable.create(:var_id=>1, :dataset_id=>5)
    assert !(variable.valid?), "variable cree sans correspondre a un dataset"
  end

  
#  def test_should_belong_to_a_dataset
#    variable = Variable.create(:var_id=>3, :dataset_id=>2)
#    dataset = Dataset.find(:all, :conditions => 'id = ' + (variable.dataset_id).to_s)
#    assert(dataset.length>0, "le dataset " + (variable.dataset_id).to_s + " n'existe pas !")
#    assert( !(variable.dataset.nil?), "pas de dataset correspondant")
#  end
end
