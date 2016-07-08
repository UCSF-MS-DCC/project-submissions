# Controller that handles the /projects page.
class ProjectsController < ApplicationController

	def index
		@projects = Project.all
		@project = Project.new
	end

	def new
		@project = Project.new
	end

	def create
		@project = Project.new(project_params)

		# The respond to here is telling you that this action accepts an ajax request. in fact, it will call the create.js.erb file located in view/projects...
		respond_to do |format|
			if @project.save
				format.js 
				# Eventually I wanted to set this up so that Jorge would receive an email whenever someone added a project but the website never took off.
				# ProjectApprover.send_approval_email(@project).deliver
			else
				format.js { render 'notifications.js.erb'}
			end
		end

	end

	private 

	# This is neccessary because of rails 'strong parameters'.
	def project_params
		params.require(:project).permit(:title, :author)
	end

end
