class ApplicationController < ActionController::Base
	include CanCan::ControllerAdditions
  protect_from_forgery with: :exception

  def raise_not_found
  	redirect_to "/"
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to "/"
  end  

  def ssl_required?
    true
  end

  def check_user
    if current_user
    else
      redirect_to root_path
    end
  end  

end
