# Application controller is the 'main controller' all other controllers are going to inherit from this application controller
class ApplicationController < ActionController::Base
  # While CanCanCan is the gem we are using, the model used is simply 'CanCan'. I think CanCan was deprecated and so 
  # CanCanCan took over but they didn't bother chaning the model name. Regardless, this is used for authentication and authorization. 
  include CanCan::ControllerAdditions
  protect_from_forgery with: :exception

  # Shared action amongst all controllers that redirects to the 'not_found' path when a user tries to visit a route that doesn't exist.
  def raise_not_found
  	redirect_to notfound_path
  end

  def not_found
  end  

  def not_authorized
  end

  # When a user visits a page that they don't have the proper authorization to visit, this is called. To check out who has what privleges, see
  # app/models/ability.rb
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to '/notauthorized'
  end  

  # Enable sthe use of SSL
  def ssl_required?

    true
  end
end
