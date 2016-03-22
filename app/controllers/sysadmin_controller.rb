class SysadminController < ApplicationController
	before_action :authorize_user

	def index
		@sysadmin = Sysadmin.first
	end

	def update
		@sysadmin = Sysadmin.find(params[:id])
		@sysadmin.update_attributes(content: params[:sysadmin][:content])
		redirect_to sysadmin_index_path
	end

	private

	def authorize_user
		if current_user
			authorize! :index, @index
		else
			redirect_to root_path
		end
	end

end
