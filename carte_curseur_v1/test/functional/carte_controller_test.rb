require File.dirname(__FILE__) + '/../test_helper'
require 'carte_controller'

# Re-raise errors caught by the controller.
class CarteController; def rescue_action(e) raise e end; end

#class CarteControllerTest < Test::Unit::TestCase

class CarteControllerTest < ActionController::TestCase
  fixtures :conflitsexts, :datasets, :variables, :var_labels, :fips_cow_codes

  def setup
    @controller = CarteController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # test verifiant la selection du browser
  def test_should_get_list_with_xml
    @request.headers['HTTP_ACCEPT'] = "application/xhtml+xml"
    get :list
    assert_response :success
    assert_not_nil assigns(:browser)
    assert_equal "moz", assigns(:browser)
#    assert_response :success
    assert_equal "application/xhtml+xml; charset=utf-8", @response.headers['type']
  end

  # test verifiant la selection du browser
  def test_should_get_list_with_vml
    @request.headers['HTTP_ACCEPT'] = "*/*"
    get :list
    assert_response :success
    assert_not_nil assigns(:browser)
    assert_equal "ie", assigns(:browser)
  end

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




#  def test_datasets_are_assigned_properly
#    get :index
#    assert_equal 2, assigns(@dat).size
#  end
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


#  def test_index
#    get :index
#    #assert_response :success
#    assert_response :missing
#    #assert_template 'list'
#  end

#  def test_list
#    get :list
#
#    assert_response :success
#    assert_template 'list'
#
#    assert_not_nil assigns(:conflitsexts)
#  end

#  def test_show
#    get :show, :id => 1
#
#    assert_response :success
#    assert_template 'show'
#
#    assert_not_nil assigns(:conflitsext)
#    assert assigns(:conflitsext).valid?
#  end
#
#  def test_new
#    get :new
#
#    assert_response :success
#    assert_template 'new'
#
#    assert_not_nil assigns(:conflitsext)
#  end

#  def test_create
#    num_conflitsexts = Conflitsext.count
#
#    post :create, :conflitsext => {}
#
#    assert_response :redirect
#    assert_redirected_to :action => 'list'
#
#    assert_equal num_conflitsexts + 1, Conflitsext.count
#  end

#  def test_edit
#    get :edit, :id => 1
#
#    assert_response :success
#    assert_template 'edit'
#
#    assert_not_nil assigns(:conflitsext)
#    assert assigns(:conflitsext).valid?
#  end

#  def test_update
#    post :update, :id => 1
#    assert_response :redirect
#    assert_redirected_to :action => 'show', :id => 1
#  end
#
#  def test_destroy
#    assert_not_nil Conflitsext.find(1)
#
#    post :destroy, :id => 1
#    assert_response :redirect
#    assert_redirected_to :action => 'list'
#
#    assert_raise(ActiveRecord::RecordNotFound) {
#      Conflitsext.find(1)
#    }
#  end
end
