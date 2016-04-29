class MyoController < ApplicationController
	before_action :check_user
	authorize_resource :class => false
		
	def index
	end

	def new
	end

	def create
		@participant = MyoParticipant.new(participant_params)
		respond_to do |format|
			if @participant.save
				format.js 
			else
				format.js { render 'notifications.js.erb'}
			end
		end
	end

	def update
		@participant = MyoParticipant.find(params["id"])
		@participant.update_attributes(participant_params)
		redirect_to myo_participants_path
	end

	def redcap
		@data = CSV.parse(redcap_data)
		@data = @data.transpose
	end

	def download_redcap_data
		@data = redcap_data

		respond_to do |format|
			format.html
	    format.csv do
	    	response.headers['Content-Disposition'] = 'attachment; filename="BoveRemoteEDSS.csv"'
	     	render :csv => @data
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

	def upload
		@participants = MyoParticipant.all
	end

	def show_visit
		@visit = TracVisit.find(params["id"])
		@myo_files = @visit.myo_files
	end

	def new_visit
		@participant = MyoParticipant.find(params["id"])
		@visit = @participant.trac_visits.new
		@myo_files = @visit.myo_files.build
	end

	def create_visit
		@visit = TracVisit.new(visit_params)
		if @visit.save
			params[:myo_files]['file'].each do |a|
				@myo_file = @visit.myo_files.create!(:file => a)
			end				
			render "show_visits"
		end
	end

	def show_visits
		@participant = MyoParticipant.find(params["id"])
		@visits = @participant.trac_visits
	end	

	def update_visit	
		@visit = TracVisit.find(params["id"])
		params[:myo_files]['file'].each do |a|
			@myo_file = @visit.myo_files.create!(:file => a)
		end		
		redirect_to myo_participants_path
	end


	private

	def redcap_data
		url = URI.parse(ENV['myo_api_url'])

		post_args = {
			'token' => ENV['myo_api_token'],
			'content' => 'record',
			'format' => 'csv',
			'type' => 'flat',
			'rawOrLabelHeaders' => 'label'
		}
		request= Net::HTTP.post_form(url, post_args)
		request.body
	end

	def participant_params
		params.require(:myo_participant).permit(:participant_id, :tracms_myo_id, :name, :scheduled_date, :exam_date, :myo_visit, :redcap_intake_q, :redcap_ms_info, :redcap_whodas, :redcap_health_intake, :mrn)
	end

	def visit_params
		params.require(:trac_visit).permit(:visit_date, :myo_participant_id, myo_files_attributes: [:id, :trac_visit_id, :file])
	end

end