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

	def upload
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

end