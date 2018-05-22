class PredssController < ApplicationController

=begin

In brief:
CONTROLLER				Validate APIKey exists
CONTROLLER				Attempt to retrieve redcap dataset from API using APIKey
CONTROLLER				If no dataset, return error
CONTROLLER				If dataset:
CONTROLLER					use mapping from redcap variables to predss variables to create new redcaps_ar
CONTROLLER					for each redcap in array:
CONTROLLER->MODELS		instantiate selected EDSS algo model and pass it the relabeled redcap record
CONTROLLER<-MODELS		call the various object methods to perform calculation
CONTROLLER<-MODELS		retrieve array of results for record and add to all_results array
VIEW<-MODELS				corresponding view uses all_results to display
CONTROLLER?					view can call new controller method to export results to CSV(?)

=end

	require 'net/http'
	#	before_action :authenticate_user!
	#	authorize_resource :class => false

	# Setting up our actions to respond to both html and CSV requests.
	respond_to :html, :csv

	def index
		#show API key submission forms for each version of PREDSS
	end

	def bove3_results
		# V3 of Goodin/Bove that expands on V2 w/ a few mods

		# Redirect to the not authorized page if the redcap is empty or invalid.
		session[:return_to] ||= request.referer
		if params[:APIKey].empty? || params[:APIKey].nil?
			redirect_to session.delete(:return_to)
		end
		# get json string of redcap data
		@redcaps = retrieve_redcap_data(params[:APIKey])
		# if nothing returned, fail
		redirect_to notauthorized_path and return if @redcaps.nil?

		# convert JSON to array of arrays
		@redcaps_ar = JSON.parse(@redcaps)

=begin
		# field renaming map
		# V3 variables are self-describing in the REDCap and do not require mapping
		# rename all fields and put into a new array of sub-arrays
		@relabeled_ar = []
		@redcaps_ar.each do |r|
			rh = r.map {|k, v| [mappings[k], v] }.to_h
			@relabeled_ar.push(rh)
		end
		@redcaps_ar = @relabeled_ar
=end

		# array to contain each bove2 object
		@all_results = []
		@incomplete_records = []
		@redcaps_ar.each do |redcap|

			if not redcap["patient_reported_edss_v3_complete"].to_i == 2 then
				# record is incomplete!
				@incomplete_records << redcap["record_id"]
				next
			end
			# initialize object w/ this record's REDCap values
			emod = Bove3Calculation.new(redcap)
			#puts bov.pretty_inspect
			# calculate functional system scores f1-8
			emod.calculate_sys_functional_scores
			# calculate fs2-5
			emod.calculate_fs_nums
			# calculate edss
			emod.calculate_edss
			# calculate AI
			emod.calculate_AI

			#puts "#{bov.record_id} EDSS = #{bov.calc_edss} \t AI #{bov.calc_ai}"
			@all_results << emod
		end
	end

	def goodin_results
		# This method uses the goodin_calculation model to parse the incoming redcap data, and generate the required scores.
		# The variable calc is just holding all the redcap scores in a single variable to more easily parse when determining individual scores.

		# Redirect to the not authorized page if the redcap empty or invalid.
		session[:return_to] ||= request.referer
		if params[:APIKey].empty? || params[:APIKey].nil?
			redirect_to session.delete(:return_to)
		end

		# fetch metadata to determine project. default to genetics.
		redcap_metadata = retrieve_redcap_metadata(params[:APIKey])
		meta = JSON.parse(redcap_metadata)


		# look for field called b3 and f5tb to verify it's a goodin.
		# b4 implies bove v1

#debugger

		meta.each do |m|
			if m['form_name']=='multiple_sclerosis_information_patient_scoring'
					@project = 'tracms'
					break
				elsif m['form_name']=='family_information_form'
					@project = 'genetics'
					break
				elsif m['form_name']=='motor_patient_intake_q'
					@project = 'motor study'
					break
				elsif m['form_name']=='ucsf_epic_update_questionnaire'
					@project = 'epic'
					break
			else
				@project = m['form_name']
			end
		end
		#	 participant['ucsf_bovegoodin_update_questionnaire_timestamp']

		if @project.nil?
			@msg = 'Could not identify REDCap project -- aborting PREDSS scoring attempt.'
			return
		end

		@headers = ["Timestamp","Record ID", "Name", "EDSS", "AI", "SFS","NRS", "MDS"]

		redcap_data = retrieve_redcap_data(params[:APIKey])
		calc = GoodinCalculation.new(JSON.parse(redcap_data), @project)
#		edss = calc.edss_histogram(calc.data_set)
#		sfs = calc.sfs_histogram(calc.data_set)
#		ai = calc.ai_histogram(calc.data_set)
		ids = calc.record_ids(calc.data_set)

		@all_results = ids

		# Creating a csv to store user's scores.
		csv_string = CSV.generate do |csv|
			csv << @headers
			ids.each do |participant|
				csv << participant.values
			end
		end
		# The respond_to format here is what allows for the download of the csv file after clicking the button and supplying the proper API credentials.
		respond_to do |format|
			format.html
			format.csv do
				response.headers['Content-Disposition'] = 'attachment; filename="Goodin_PREDSS_Results.csv"'
				render :csv => csv_string
			end
		end
	end

	def bove_calculate
		# More or less the same as the goodin_calculate only the bove_calculation model is being called.
		redirect_to notauthorized_path and return if redcap_data(params[:boveAPI]).nil?
		calc = BoveCalculation.new(JSON.parse(redcap_data(params[:boveAPI])))
		edss = calc.edss_histogram(calc.data_set)
		sfs = calc.sfs_histogram(calc.data_set)
		ai = calc.ai_histogram(calc.data_set)
		ids = calc.record_ids(calc.data_set)

		csv_string = 	CSV.generate do |csv|
			csv << ["record_id", "first_name", "last_name", "sfs", "edss", "aI", "nrs", "mds", "Ambulation", "Cerebellar", "Brainstem", "Sensory", "Bowel/Bladder", "Vision", "Cerebral", "Pyramidal"]
			ids.each do |participant|
				csv << participant.values
			end
		end
		respond_to do |format|
			format.html
			format.csv do
				response.headers['Content-Disposition'] = 'attachment; filename="BoveRemoteEDSS.csv"'
				render :csv => csv_string
			end
		end
	end

	def bove2a_results
		# V2 of Goodin/Bove that fixes pyramidal<->ambulation issues

		redirect_to notauthorized_path and return if redcap_data(params[:bove2APIkey]).nil?

		# json string of redcap data
		@redcaps = redcap_data(params[:bove2APIkey])
		# convert JSON to array of arrays
		@redcaps_ar = JSON.parse(@redcaps)

		# field renaming map
		mappings = {
				"record_id" => "record_id",
				"xxxx" => "xxxx",
				"ucsf_bovegoodin_update_questionnaire_timestamp" => "ucsf_bovegoodin_update_questionnaire_timestamp",
				"a1" => "walk_overall",
				"a21" => "walk_pct_unaided",
				"a22" => "walk_pct_unilateral",
				"a23" => "walk_pct_bilateral",
				"a24" => "walk_pct_wheelchair",
				"b1" => "visual_double",
				"b2" => "swallowing",
				"b3" => "vertigo",
				"b4" => "hearing",
				"bal" => "balance",
				"c1" => "mood",
				"f1a" => "strength_right_arm",
				"f1b" => "strength_left_arm",
				"f1c" => "strength_right_leg",
				"f1d" => "strength_left_leg",
				"f1fl" => "strength_face_left",
				"f1fr" => "strength_face_right",
				"f2a" => "coord_right_arm",
				"f2b" => "coord_left_arm",
				"f2c" => "coord_right_leg",
				"f2d" => "coord_left_leg",
				"f2s" => "speaking",
				"f4a" => "sense_right_arm",
				"f4b" => "sense_left_arm",
				"f4c" => "sense_right_leg",
				"f4d" => "sense_left_leg",
				"f4fl" => "sense_face_left",
				"f4fr" => "sense_face_right",
				"f5ta" => "bowel",
				"f5tb" => "bladder",
				"f6a" => "visual_right",
				"f6b" => "visual_left",
				"f7t" => "cog_overall",
				"f8a" => "spasm_right_arm",
				"f8b" => "spasm_left_arm",
				"f8c" => "spasm_right_leg",
				"f8d" => "spasm_left_leg",
				"fs" => "functional_overall",
				"ucsf_bovegoodin_update_questionnaire_complete" => "ucsf_bovegoodin_update_questionnaire_complete"
		}

		# rename all fields and put into a new array of sub-arrays
		@relabeled_ar = []
		@redcaps_ar.each do |r|
			rh = r.map {|k, v| [mappings[k], v] }.to_h
			@relabeled_ar.push(rh)
		end

		# array to contain each bove2 object
		@results = []
		@relabeled_ar.each do |record|
			# initialize object w/ this record's REDCap values
			bov = Bove2aCalculation.new(record)
			#puts bov.pretty_inspect
			# calculate functional system scores f1-8
			bov.calculate_sys_functional_scores
			# calculate fs2-5
			bov.calculate_fs_nums
			# calculate edss
			bov.calculate_edss
			# calculate AI
			bov.calculate_AI

			#puts "#{bov.record_id} EDSS = #{bov.calc_edss} \t AI #{bov.calc_ai}"
			@results << bov
		end
	end

	def bove2b_results
		# V2 of Goodin/Bove that fixes pyramidal<->ambulation issues
		redirect_to notauthorized_path and return if redcap_data(params[:bove2APIkey]).nil?

		# json string of redcap data
		@redcaps = redcap_data(params[:bove2APIkey])
		# convert JSON to array of arrays
		@redcaps_ar = JSON.parse(@redcaps)

		# field renaming map
		mappings = {
				"record_id" => "record_id",
				"xxxx" => "xxxx",
				"ucsf_bovegoodin_update_questionnaire_timestamp" => "ucsf_bovegoodin_update_questionnaire_timestamp",
				"a1" => "walk_overall",
				"a21" => "walk_pct_unaided",
				"a22" => "walk_pct_unilateral",
				"a23" => "walk_pct_bilateral",
				"a24" => "walk_pct_wheelchair",
				"b1" => "visual_double",
				"b2" => "swallowing",
				"b3" => "vertigo",
				"b4" => "hearing",
				"bal" => "balance",
				"c1" => "mood",
				"f1a" => "strength_right_arm",
				"f1b" => "strength_left_arm",
				"f1c" => "strength_right_leg",
				"f1d" => "strength_left_leg",
				"f1fl" => "strength_face_left",
				"f1fr" => "strength_face_right",
				"f2a" => "coord_right_arm",
				"f2b" => "coord_left_arm",
				"f2c" => "coord_right_leg",
				"f2d" => "coord_left_leg",
				"f2s" => "speaking",
				"f4a" => "sense_right_arm",
				"f4b" => "sense_left_arm",
				"f4c" => "sense_right_leg",
				"f4d" => "sense_left_leg",
				"f4fl" => "sense_face_left",
				"f4fr" => "sense_face_right",
				"f5ta" => "bowel",
				"f5tb" => "bladder",
				"f6a" => "visual_right",
				"f6b" => "visual_left",
				"f7t" => "cog_overall",
				"f8a" => "spasm_right_arm",
				"f8b" => "spasm_left_arm",
				"f8c" => "spasm_right_leg",
				"f8d" => "spasm_left_leg",
				"fs" => "functional_overall",
				"ucsf_bovegoodin_update_questionnaire_complete" => "ucsf_bovegoodin_update_questionnaire_complete"
		}

		# rename all fields and put into a new array of sub-arrays
		@relabeled_ar = []
		@redcaps_ar.each do |r|
			rh = r.map {|k, v| [mappings[k], v] }.to_h
			@relabeled_ar.push(rh)
		end

		# array to contain each bove2 object
		@results = []
		@relabeled_ar.each do |record|
			# initialize object w/ this record's REDCap values
			bov = Bove2bCalculation.new(record)
			#puts bov.pretty_inspect
			# calculate functional system scores f1-8
			bov.calculate_sys_functional_scores
			# calculate fs2-5
			bov.calculate_fs_nums
			# calculate edss
			bov.calculate_edss
			# calculate AI
			bov.calculate_AI

			#puts "#{bov.record_id} EDSS = #{bov.calc_edss} \t AI #{bov.calc_ai}"
			@results << bov
		end
	end

	private

	def retrieve_redcap_data(key)
		# Function that calls to the redcap db for data.
		url = URI.parse("https://redcap.ucsf.edu/api/")
		post_args = {
			'token' => key,
			'content' => 'record',
			'format' => 'json',
			'type' => 'flat',
			'exportSurveyFields' =>'true'
		}
		request = Net::HTTP.post_form(url, post_args)
		request.body
	end

	def retrieve_redcap_metadata(key)
		# Function that calls to the redcap db for data.
		url = URI.parse("https://redcap.ucsf.edu/api/")
		post_args = {
				'token' => key,
				'content' => 'metadata',
				'format' => 'json'
		}
		request = Net::HTTP.post_form(url, post_args)
		request.body
	end
end
