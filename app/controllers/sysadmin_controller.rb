class SysadminController < ApplicationController
	before_action :authorize_user

	def index
	end

	def show
	end

	private

	def authorize_user
		authorize! :index, @index
	end

end
