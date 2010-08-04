class StoreController < ApplicationController
  before_filter :find_cart, :except => :empty_cart
  
  def index
    @products = Product.find_products_for_sale
    respond_to do |format|
      format.html
      format.xml {render :layout => false, :xml => @products.to_xml}
      format.json {render :layout => false, :json => @products.to_xml}
    end
  end
  
  def add_to_cart
    product = Product.find(params[:id])
    @current_item = @cart.add_product(product)
    respond_to do |format|
      format.js if request.xhr?
      format.html {redirect_to_index}
    end
  rescue ActiveRecord::RecordNotFound
    logger.error("Attempt to access invalid product #{params[:id]}")
    redirect_to_index("Invalid Product")
  end
  
  def empty_cart
    session[:cart] = nil
    respond_to do |format|
      format.js if request.xhr?
      format.html {redirect_to_index}
    end
  end
  
  def checkout
    if request.post? and params[:order]
        @order = Order.new(params[:order])
        @order.add_line_items_from_cart(@cart)
        if @order.save
            session[:cart] = nil
            redirect_to_index("Thank you for your order")
        else
            render :action => 'checkout'
        end
    end
    @disabledLink = true
    if @cart.items.empty?
      redirect_to_index("Your cart is empty")
    else
      @order = Order.new
    end
  end
  
  def save_order
  end

protected
  def authorize
  end

private
  def find_cart
    @cart = (session[:cart] ||= Cart.new)
  end
  
  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => 'index'
  end
  
end
