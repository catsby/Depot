require 'test_helper'

class UserStoriesTest < ActionController::IntegrationTest
  fixtures :products


  # Replace this with your real tests.
  test "Story 1" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby_book)
    
    get "/store/index"
    assert_response :success
    assert_template "index"
    
    xml_http_request :put, "/store/add_to_cart", :id => ruby_book.id
    assert_response :success
    
    cart = session[:cart]
    assert_equal 1, cart.items.size
    assert_equal ruby_book, cart.items[0].product
    
    post "/store/checkout"
    assert_response :success
    assert_template "checkout"
    
    post_via_redirect "/store/checkout",
                      :order => {:name      => "Dave Thomas",
                                 :address   => '123 the street',
                                 :email     => 'the@email.com',
                                 :pay_type  => 'check'}
    assert_response :success
    assert_template 'index'
    assert_equal 0, session[:cart].items.size
    
  end
end
