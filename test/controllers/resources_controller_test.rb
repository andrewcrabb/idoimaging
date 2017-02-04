require 'test_helper'

class ResourcesControllerTest < ActionController::TestCase
  setup do
    @resource = resources(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:resources)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create resource" do
    assert_difference('Resource.count') do
      post :create, resource: { author_id: @resource.author_id, description: @resource.description, feature_id: @resource.feature_id, identifier: @resource.identifier, last_seen: @resource.last_seen, last_tested: @resource.last_tested, program_id: @resource.program_id, type: @resource.type, url: @resource.url }
    end

    assert_redirected_to resource_path(assigns(:resource))
  end

  test "should show resource" do
    get :show, id: @resource
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @resource
    assert_response :success
  end

  test "should update resource" do
    patch :update, id: @resource, resource: { author_id: @resource.author_id, description: @resource.description, feature_id: @resource.feature_id, identifier: @resource.identifier, last_seen: @resource.last_seen, last_tested: @resource.last_tested, program_id: @resource.program_id, type: @resource.type, url: @resource.url }
    assert_redirected_to resource_path(assigns(:resource))
  end

  test "should destroy resource" do
    assert_difference('Resource.count', -1) do
      delete :destroy, id: @resource
    end

    assert_redirected_to resources_path
  end
end
