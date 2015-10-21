class ProjectsController < ApplicationController

	def new
		@project = Project.new
	end

	def create
		@project = Project.new(project_params)

		respond_to do |format|
			if @project.save
				format.html { redirect_to root_url, notice: "Project was succesfully added."}
				format.js 
			else
				format.html {render action: "new"}
				format.json { render json: @project.errors, status: unprocessable_entity}
			end
		end

		# redirect_to root_url
	end

	private 

	def project_params
		params.require(:project).permit(:title, :author, :title, :project_description, :data_description, :data_frequency, :humanizer_answer, :humanizer_question_id )
	end
end
