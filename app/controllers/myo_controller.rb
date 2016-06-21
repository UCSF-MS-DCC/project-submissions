class MyoController < ApplicationController
	before_action :authenticate_user!
	authorize_resource :class => false
		
	def index
		@visits = TracVisit.where("visit_date < ?", DateTime.now + 7)
		@participants = []
		@visits.each do |visit|
			@participants << MyoParticipant.find(visit.myo_participant_id)
		end
		@demographics = get_demographics
		@goodin_edss_scores = get_goodin
		asd
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

	def get_demographics
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
		@data = CSV.parse(request.body).transpose
		@data_no_transpose = CSV.parse(request.body).transpose
		demographic_data = {}
		@age = Hash.new(0)
		@sex = Hash.new(0)
		@relapses = Hash.new(0)
		@edss_scores = Hash.new(0)
		@disease_type = Hash.new(0)
		
		#Sex- We do this because the question about sex is asked multiple times through all instruments.
		@data[16].each{|key| @sex[key]+=1}

		#Age- We do this because the question about age is asked multiple times through all instruments.
		@data[15].each{|key| @sex[key]+=1}
		@data.each do |x|
			if x[0] 
				if x[0] == "Please put your sex:"
					x.each{|key| @sex[key]+=1}
				end
				if x[0] == "Age"
					x.each{|key| @age[key]+=1}
				end
				if x[0] == "How many relapses have you had?"
					x.each{|key| @relapses[key]+=1}
				end			
				if x[0].include?("Patient-entered Diagnosis of type of demyelinating disease")
					@disease_type[x[0]] = x.count("Checked")
				end
			else
			end
			@subject_ids = @data_no_transpose[1]
			@data_no_transpose.each do |subject|
				if subject[0] == "Final EDSS Score"
					@scores = subject
				end
			end
			@subject_ids.zip(@scores).each do |id, score|
				@edss_scores[id] = score
			end
		end
		[@age, @sex, @relapses, @disease_type, @edss_scores]
	end

	def get_goodin
		url = URI.parse(ENV['myo_api_url'])
		post_args = {
			'token' => ENV['myo_api_token'],
			'content' => 'record',
			'format' => 'json',
			'type' => 'flat',
			'rawOrLabelHeaders' => 'raw'
		}
		request= Net::HTTP.post_form(url, post_args)
		@goodin_scores = GoodinCalculation.new(JSON.parse(request.body))
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