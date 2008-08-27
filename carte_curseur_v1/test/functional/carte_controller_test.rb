require File.dirname(__FILE__) + '/../test_helper'
require 'carte_controller'

# Re-raise errors caught by the controller.
class CarteController; def rescue_action(e) raise e end; end

#class CarteControllerTest < Test::Unit::TestCase

class CarteControllerTest < ActionController::TestCase
  fixtures :conflitsexts, :datasets, :variables, :var_labels, :fips_cow_codes, :dataset_1, :dataset_2

  def setup
    @controller = CarteController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # tests verifiant la selection du browser
  def test_should_get_list_with_xml
    @request.headers['HTTP_ACCEPT'] = "application/xhtml+xml"
    get :list
    assert_response :success
    assert_not_nil assigns(:browser)
    assert_equal "moz", assigns(:browser)
#    assert_response :success
    assert_equal "application/xhtml+xml; charset=utf-8", @response.headers['type']
  end

  def test_should_get_list_with_vml
    @request.headers['HTTP_ACCEPT'] = "*/*"
    get :list
    assert_response :success
    assert_not_nil assigns(:browser)
    assert_equal "ie", assigns(:browser)
  end

  # tests verifiant la redirection en fonction des url
  def test_should_redirect_index_to_list_xml
    @request.headers['HTTP_ACCEPT'] = "application/xhtml+xml"
    get :index
    assert_response :success
    assert_not_nil assigns(:browser)
    assert_equal "moz", assigns(:browser)
#    assert_response :success
    assert_equal "application/xhtml+xml; charset=utf-8", @response.headers['type']
  end

  def test_should_redirect_index_to_list_vml
    @request.headers['HTTP_ACCEPT'] = "*/*"
    get :index
    assert_response :success
    assert_not_nil assigns(:browser)
    assert_equal "ie", assigns(:browser)
  end

  # tests sur la bonne affectation des variables

  def test_refresh_var
    
    get :refresh_var, :datas => 1
    assert_response :success
    assert_equal 4, assigns(:var_select).size
    assert_equal 17, assigns(:citation).size
    assert_equal 5, assigns(:vars).size
    assert_equal 2, assigns(:datasets2).size
    assert_equal 2, assigns(:datasets).size
    assert_equal 3, assigns(:dat).size
  end

  def test_show_over_conflicts_zone
    get :show_over, :id => "lt35lg110rd2000", :dataset => 1, :variable => 1
    assert_response :success
    assert_equal 1, assigns(:dataset).size
    assert_equal 1, assigns(:variable).size
    assert_equal 1, assigns(:conflitsexts).size
  end

  def test_show_over_country
    get :show_over, :id => 'FR19462003', :dataset => 1, :variable => 8
    assert_response :success
    assert_equal 1946, assigns(:debut_periode)
    assert_equal 1, assigns(:dataset).size
    assert_equal 1, assigns(:variable).size
    assert_nil assigns(:conflitsexts)
    assert_equal 'FR19462003', assigns(:id)
    assert_equal "220", assigns(:cow_code)
    assert_equal '2', assigns(:identifierccode1_var)
    assert_equal '3', assigns(:identifieryear_var)
    assert_equal 3, assigns(:donnees_frise).size
  end

  # tests verifiant les vues rendues
  def test_good_number_of_datasets_in_select_box
    @request.headers['HTTP_ACCEPT'] = "application/xhtml+xml"
    get :index
    assert_select "select", "Please choose a dataset\ndataset1\ndataset2"
    assert_select "select option", "Please choose a dataset"
  end


end
