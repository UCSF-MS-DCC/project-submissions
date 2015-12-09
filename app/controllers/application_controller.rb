class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def raise_not_found
  	redirect_to "/"
  	# render "404"
  	# Eventually clean this up and add the actual 404 page in; right now it's just a redirect.
  end
end
