class AdminController < ApplicationController
  def login
    if request.post?
      user = User.authenticate(params[:name], params[:password])
      if user
        session[:user_id] = user.id
        #redirect to original requested uri and clear session var
        uri = session[:original_uri]
        session[:original_uri] = nil
        redirect_to(uri || {:action => 'index'})
      else
        flash.now[:notice] = 'Invalid username/password'
      end
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = 'Logged out'
    redirect_to(:action => 'login')
  end

  def index
    @total_orders = Order.count
  end

end
