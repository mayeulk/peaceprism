require File.dirname(__FILE__) + '/../test_helper'

class DatasetResearchersControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:dataset_researchers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_dataset_researcher
    assert_difference('DatasetResearcher.count') do
      post :create, :dataset_researcher => { }
    end

    assert_redirected_to dataset_researcher_path(assigns(:dataset_researcher))
  end

  def test_should_show_dataset_researcher
    get :show, :id => dataset_researchers(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => dataset_researchers(:one).id
    assert_response :success
  end

  def test_should_update_dataset_researcher
    put :update, :id => dataset_researchers(:one).id, :dataset_researcher => { }
    assert_redirected_to dataset_researcher_path(assigns(:dataset_researcher))
  end

  def test_should_destroy_dataset_researcher
    assert_difference('DatasetResearcher.count', -1) do
      delete :destroy, :id => dataset_researchers(:one).id
    end

    assert_redirected_to dataset_researchers_path
  end
end
