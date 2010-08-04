require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  fixtures :users
  # Replace this with your real tests.
  test "index" do
    get :index
    assert_redirected_to :controller => "admin", :action => "login"
    assert_equal "Please log in", flash[:notice]
  end
  
  test "index with user" do
    get :index, {}, { :user_id => users(:dave).id}
    assert_response :success
    assert_template "index"
  end

  test "login" do
    dave = users(:dave)
    post :login, :name => dave.name, :password => 'secret'
    assert_redirected_to :controller => :admin, :action => 'index'
    assert_equal dave.id, session[:user_id]
  end

end