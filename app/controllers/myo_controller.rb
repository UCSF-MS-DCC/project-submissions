class MyoController < ApplicationController
	before_action :authenticate_user!
	authorize_resource :class => false
		
	def index
		@visits = TracVisit.where("visit_date < ?", DateTime.now + 7)
		@participants = []
		@visits.each do |visit|
			@participants << MyoParticipant.find(visit.myo_participant_id)
		end
		@participants = MyoParticipant.all
		update_db_from_redcap
	end

	def new
	end

	def create
		@participant = MyoParticipant.new(participant_params)
		puts @participant.id
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
	    	response.headers['Content-Disposition'] = 'attachment; filename="MyoData.csv"'
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

	def show_visits
		@participant = MyoParticipant.find(params["id"])
		@visits = @participant.trac_visits
		@max_images = 0
		@visits.each do |visit|
			if visit.myo_files.count > @max_images
				@max_images = visit.myo_files.count
			end
		end
	end	

	def show_visit
		@visit = TracVisit.find(params["id"])
		@myo_files = @visit.myo_files.all
	end

	def update_visit	
		@visit = TracVisit.find(params["id"])
		if params[:myo_files]
			params[:myo_files]['file'].each do |a|
				@myo_file = @visit.myo_files.create!(:file => a)
			end		
		end
		@visit.update_attributes(visit_params_date)
		redirect_to myo_participants_path
	end

	def new_visit
		@participant = MyoParticipant.find(params["id"])
		@visit = @participant.trac_visits.new
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

	def update_db_from_redcap
		# little bit of a beast method. Calls the redcap API and populates the DB with redcap information. A little costly because it happens
		# on every index.html page load but since this page isn't high traffic it should be OK. Otherwise we would rely on the coordinator
		# to manually import and that could lead to data issues.
		@captured_participants= []
		url = URI.parse(ENV['myo_api_url'])
		post_args = {
			'token' => ENV['myo_api_token'],
			'content' => 'record',
			'rawOrLabel' => 'label',
			'format' => 'json',
			'type' => 'flat',
			'rawOrLabelHeaders' => 'raw'
		}
		request= Net::HTTP.post_form(url, post_args)
		data = JSON.parse(request.body)

		goodin_scores = GoodinCalculation.new(data)	

		data.zip(goodin_scores.data_set).each do |physician, goodin|
			myo_participant = MyoParticipant.where(tracms_myo_id: physician["record_id"].to_i).first
			if myo_participant
				myo_participant.update_attributes(email: physician["email"], sex: physician["sex"] , dob: physician["dob"])
				if physician["date_enrolled"] != ""
					(1..8).each do |x|
						if physician["patientreportdx___" + x.to_s] == "Checked"
							@disease_number = x.to_s
						end
					end
					myo_participant.trac_visits.where(visit_date: DateTime.parse(physician["date_enrolled"])-60.days..DateTime.parse(physician["date_enrolled"])+60.days).first.update_attributes(physician_edss: physician["edss"], goodin_edss: goodin[:edss])
					myo_participant.update_attributes(onset: physician["dateonset"], case_or_control: physician["ms_or_hc"], disease_type: convert_to_disease(@disease_number))
				else
				end
			else
				@captured_participants.push(physician['record_id'])
			end
		end		
			flash[:notice] = "Participant with Tracms_myo_id: #{@captured_participants.join(" , ")} have completed a redcap survey but cannot be found in the database! Please add this/these user(s)."
			return redirect_to myo_participants_path		
	end

	def convert_to_disease(number)
		codebook = {"1"=>"RR", "2"=>"SP", "3"=>"PR", "4"=>"Optic Neuritis", "5"=>"Transverse Myelitis", "6"=>"CIS", "7"=>"RIS", "8"=>"Demyelinating disease not otherwise specified"}
			return codebook[number]
	end

	def redcap_data
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