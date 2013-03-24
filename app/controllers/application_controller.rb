class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def login_required
    if session[:user]
      return true
    end
    flash[:warning]='Por favor ingrese para continuar.'
    session[:return_to]=request.fullpath
    redirect_to :controller => "users", :action => "login"
    return false 
  end
  
  def current_user
    session[:user]
  end
  def self.current_user
    session[:user]
  end
  
  def redirect_to_stored
    if session[:return_to]
      return_to = session[:return_to]
      session[:return_to]=nil
      redirect_to return_to
    else
      redirect_to :controller=>'users', :action=>'index'
    end
  end
  
end
