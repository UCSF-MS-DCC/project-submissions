class SysadminController < ApplicationController
	before_action :check_user

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

	def check_user
		if current_user
			authorize_resource :class => false
		else
			redirect_to root_path
		end
	end

	def strong_params
		params.require(:sysadmin).permit(:title, :content)
	end

end
