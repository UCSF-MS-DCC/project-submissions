# Sysadmin hasn't really taken off but is a place where we can store information pertinent to the servers etc...
# The controller is straightforward. Information about the roles can be viewed at: app/models/ability.rb
class SysadminController < ApplicationController
	# Always make sure to authenticate user before visitng this page (contains potentially sensitive information ). No need to authorize as railsadmin does
	# this separately
	before_action :authenticate_user!
	authorize_resource :class => false

	def index
		@sysadmins = Sysadmin.all
	end

	def new
		@sysadmin = Sysadmin.new
	end

	def edit
		@sysadmin = Sysadmin.find(params[:id])
	end

	def create
		Sysadmin.create(strong_params)
		redirect_to sysadmin_index_path
	end

	def show
		@sysadmin = Sysadmin.find(params[:id])
	end


	def update
		@sysadmin = Sysadmin.find(params[:id])
		@sysadmin.update_attributes(content: params[:sysadmin][:content], title: params[:sysadmin][:title])
		redirect_to sysadmin_path
	end

	private

	def strong_params
		params.require(:sysadmin).permit(:title, :content)
	end

end
