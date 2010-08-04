require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  
  # Replace this with your real tests.
  test "Invalid with empty attributes" do
    product = Product.new
    assert !product.valid?
    assert product.errors.invalid?(:title)
    assert product.errors.invalid?(:description)
    assert product.errors.invalid?(:price)
    assert product.errors.invalid?(:image_url)
  end
  
  test "Positive Price" do
    product = Product.new(:title        => "My Book Title",
                          :description  => "stuff and things",
                          :image_url    => "stuff.jpg")
    product.price = -1
    assert !product.valid?
    assert_equal "should be at least $0.01", product.errors.on(:price)

    product.price = 0
    assert !product.valid?
    assert_equal "should be at least $0.01", product.errors.on(:price)
    
    product.price = 1
    assert product.valid?
  end
  
  test "Image URL" do
    ok  = %w{ fred.gif fred.jpg freg.png FRED.jpg FRED.Jpg http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    
    ok.each do |name|
      product = Product.new(:title        => "My Book",
                            :description  => "my description",
                            :price        => 1,
                            :image_url    => name)
      assert product.valid?, product.errors.full_messages
    end
    bad.each do |name|
      product = Product.new(:title        => "My Book",
                            :description  => "my description",
                            :price        => 1,
                            :image_url    => name)
      assert !product.valid?, "saving #{name}"
    end
  end
  
  test "unique title" do
    product = Product.new(:title        => products(:ruby_book).title,
                          :description  => "test",
                          :price        => 1,
                          :image_url    => "fred.gif" )
    assert !product.save
    assert_equal I18n.translate('activerecord.errors.messages.taken'), product.errors.on(:title)
  end
end
