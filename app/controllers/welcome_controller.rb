class WelcomeController < ApplicationController
  def index
  	@projects = Project.all
  	@project = Project.new
  end
end
