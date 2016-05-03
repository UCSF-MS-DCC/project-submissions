require 'test_helper'

class MyoFilesControllerTest < ActionController::TestCase
  setup do
    @myo_file = myo_files(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:myo_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create myo_file" do
    assert_difference('MyoFile.count') do
      post :create, myo_file: { file: @myo_file.file, trac_visit_id: @myo_file.trac_visit_id }
    end

    assert_redirected_to myo_file_path(assigns(:myo_file))
  end

  test "should show myo_file" do
    get :show, id: @myo_file
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @myo_file
    assert_response :success
  end

  test "should update myo_file" do
    patch :update, id: @myo_file, myo_file: { file: @myo_file.file, trac_visit_id: @myo_file.trac_visit_id }
    assert_redirected_to myo_file_path(assigns(:myo_file))
  end

  test "should destroy myo_file" do
    assert_difference('MyoFile.count', -1) do
      delete :destroy, id: @myo_file
    end

    assert_redirected_to myo_files_path
  end
end
