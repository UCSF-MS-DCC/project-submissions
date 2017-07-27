# MyoController is responsible for handling all things related to Dr. Graves TracMS project.
class MyoController < ApplicationController
	# Always make sure to authenticate and authorize user before visitng this page (contains potentially sensitive information ). Check 
	# app/models/ability.rb for authorization informaton
	before_action :authenticate_user!
	authorize_resource :class => false

	require 'net/http'

	def index
		# The missing participants instance variable serves to show the coordinator which individuals have filled out a redcap form
		# but HAVE NOT been added manually to the DB via the participants page. The update_db_from_redcap method is a very lage method called on the 
		# myo participant model (via MyoParticipant.rb) and is worth checking out.

		# Destructure array that is returned from update_db_from_redcap:
		@missing_participants, @uncaptured_visits = MyoParticipant.update_db_from_redcap
		@participants = MyoParticipant.all
	end

	def create
		# Creating an ajax route so coordinator can upload a participant easily.
		@participant = MyoParticipant.new(participant_params)
		respond_to do |format|
			if @participant.save
				# If the participant is saved, you should render the create.js.erb file found in views/myo/create.js.erb
				format.js 
			else
				# Otherwise render the notifications file should be rendered which explains the error to the user.
				format.js { render 'notifications.js.erb'}
			end
		end
	end

	def update
		# Standard update path, searches for the proper individual and then updates.
		@participant = MyoParticipant.find(params["id"])
		@participant.update_attributes(participant_params)
		redirect_to myo_participants_path
	end

	def redcap
		# This method is what is called for vieiwing the redcap data at /myo/redcap. The following function is what is called when after clicking: 
		# "download redcap data" at redcap.html.erb
		# The method 'redcap_data' is a simple call to the redcap server to obtain information.
		# Note, because the way data is stored via the redcap surveys it's always best to download the data straight from redcap. 
		@data = CSV.parse(redcap_data)
		# Transpose is a nifty function that makes the data easier to read.
		@data = @data.transpose
	end

	def download_redcap_data
		# Allows for the actual downloading of redcap data.
		@data = redcap_data
		respond_to do |format|
	    format.csv do
				render :csv => @data, filename: "redcap_data.csv"				
	   	end
	  end				
	end

	def download_computed_data
		# This is the method that is called from the /myo page where the link reads "Download Redcap Data and Upload Database". The 'prepare_completed_csv' 
		# method is a simple way to take the rails models for each individual (and their visits) and put their information into a csv sheet. To see what items are
		# being sent to the CSV sheet, checkout schema.rb and look at the TracVisit model.
		respond_to do |format|
			@data = MyoParticipant.prepare_completed_csv
			format.csv do
	     	render :csv => @data, filename: "computed_data.csv"				
			end
	  end				

	end	

	def participants
		@participants = MyoParticipant.all
		@participant = MyoParticipant.new
	end

	def show_participant
		@participant = MyoParticipant.find(params["id"])
	end

	def show_visits
		# Method that displays all the visits for an individual.
		@participant = MyoParticipant.find(params["id"])
		@visits = @participant.trac_visits
		# The @max_images holder is to help with formatting in the view. See 'show_visits.html.erb' for more.
		@max_images = 0
		@visits.each do |visit|
			if visit.myo_files.count > @max_images
				@max_images = visit.myo_files.count
			end
		end
	end	

	def show_visit
		# Method that ONLY shows one visit when it is clicked on (as opposed to all visits an individual has- see 'show_visits' method).
		@visit = TracVisit.find(params["id"])
		@myo_files = @visit.myo_files.all
	end

	def update_visit	
		# When updating a visit you only want to update the files if a new file is being added.
		@visit = TracVisit.find(params["id"])
		if params[:myo_files]
			params[:myo_files]['file'].each do |a|
				@myo_file = @visit.myo_files.create!(:file => a)
			end		
		end
		@visit.update_attributes(visit_params_date)
		flash[:notice] = 'Successfully updated visit'
		redirect_to myo_participants_path
	end

	def new_visit
		@participant = MyoParticipant.find(params["id"])
		@visit = @participant.trac_visits.new
		# The build function creates the nested myo_files so that they are uploaded and attached to the apropriate visit.
		@myo_files = @visit.myo_files.build
	end

	def create_visit
		@visit = TracVisit.new(visit_params)

		if @visit.save
			if params[:myo_files]
				params[:myo_files]['file'].each do |a|
					@myo_file = @visit.myo_files.create!(:file => a)
				end				
			end
		end
		redirect_to myo_participants_path
	end

	def delete_file
		# Enables for the ajax route to delete files.
		@myo_file = MyoFile.find(params[:image_id])
		respond_to do |format|
			@myo_file.destroy
			format.js 
		end
	end

	def download_file
		@myo_file = MyoFile.find(params[:id])
		@visit = TracVisit.find(@myo_file.trac_visit_id)
	  send_file("#{Rails.root}/myo/myo_data/#{@visit.visit_date}/#{@visit.myo_participant_id}/#{@myo_file[:file]}")		
	end

	private

	def redcap_data
		# Method used to call the redcap API
		url = URI.parse(ENV['myo_api_url'])

		post_args = {
			'token' => ENV['myo_api_token'],
			'content' => 'record',
			'rawOrLabel' => 'label',
			'format' => 'csv',
			'type' => 'flat',
			'rawOrLabelHeaders' => 'label'
		}
		request= Net::HTTP.post_form(url, post_args)
		request.body
	end

	# Note, we use the different params down here because of rails 'strong parameters' which prevents us from mass assigning
	# attributes to models. View: http://edgeapi.rubyonrails.org/classes/ActionController/StrongParameters.html for more info.

	def participant_params
		params.require(:myo_participant).permit(:participant_id, :tracms_myo_id, :name, :scheduled_date, :exam_date, :myo_visit, :redcap_intake_q, :redcap_ms_info, :redcap_whodas, :redcap_health_intake, :mrn)
	end

	def visit_params
		params.require(:trac_visit).permit(:visit_date, :myo_participant_id, myo_files_attributes: [:id, :trac_visit_id, :file])
	end

	def visit_params_date
		params.require(:trac_visit).permit(:visit_date)
	end

end