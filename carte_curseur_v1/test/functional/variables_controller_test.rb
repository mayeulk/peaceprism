require File.dirname(__FILE__) + '/../test_helper'

class VariablesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:variables)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

#  def test_should_create_variable
#    assert_difference('Variable.count') do
#      post :create, :variable => { }
#  end
#
#    assert_redirected_to variable_path(assigns(:variable))
#  end

  def test_should_show_variable
    get :show, :id => variables(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => variables(:one).id
    assert_response :success
  end

  def test_should_update_variable
    put :update, :id => variables(:one).id, :variable => { }
    assert_redirected_to variable_path(assigns(:variable))
  end

  def test_should_destroy_variable
    assert_difference('Variable.count', -1) do
      delete :destroy, :id => variables(:one).id
    end

    assert_redirected_to variables_path
  end
end
