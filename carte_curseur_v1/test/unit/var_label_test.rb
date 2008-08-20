require File.dirname(__FILE__) + '/../test_helper'

class VarLabelTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end  
  
  def test_should_create_record
    varlabel = VarLabel.create(:var_id=>1, :var_key=>1, :dataset_id=>1)
    assert varlabel.valid?, "varlabel non valide"
  end
  
  def test_should_not_create_record
    varlabel = VarLabel.create(:var_id=>1, :var_key=>236, :dataset_id=>2)
    assert !(varlabel.valid?), "varlabel non valide"
  end
  
  
end
