# Controller that handles both goodin and bove EDSS pages.
class EdssController < ApplicationController
	# Always make sure to authenticate and authorize user before visitng this page (contains potentially sensitive information ). Check app/models/ability.rb
	# for authorization information
	before_action :authenticate_user!
	authorize_resource :class => false

	# Setting up our actions to respond to both html and CSV requests.
	respond_to :html, :csv

	def goodin
		# This renders the goodin.html.erb file. When you visit that file you'll notice the submit button
		# calls to the '/edss/goodin/calculate.csv' action. The respond_to :csv allows us to download the CSV file.
		# If you don't see how this previously mentioned url (.../calculate.csv) calls the below 'goodin_calculate' 
		# method, then check out 'bundle exec rake routes' and you'll see the url '/edss/goodin/calculate' points to 
		# the action 'goodin_calculate'
	end		

	def bove
		# Same as 'goodin' method with bove used.
	end

	def bove2
		# Same as 'goodin' and 'bove' method with bove2 used.
	end

	def goodin_calculate
		# This method uses the goodin_calculation model to parse the incoming redcap data, and generate the required scores. 
		# The variable calc is just holding all the redcap scores in a single variable to more easily parse when determining individual scores.
		# Redirect to the not authorized page if the redcap token is invalid.
		redirect_to notauthorized_path and return if redcap_data(params[:goodinAPI]).nil?
		calc = GoodinCalculation.new(JSON.parse(redcap_data(params[:goodinAPI])))
		edss = calc.edss_histogram(calc.data_set)
		sfs = calc.sfs_histogram(calc.data_set)
		ai = calc.ai_histogram(calc.data_set)
		ids = calc.record_ids(calc.data_set)

		# Creating a csv to store user's scores.
		csv_string = CSV.generate do |csv|
			csv << ["record_id", "first_name", "last_name", "sfs", "edss", "aI", "nrs", "mds"]
			ids.each do |participant|
				csv << participant.values
			end
		end		
		# The respond_to format here is what allows for the download of the csv file after clicking the button and supplying the proper API credentials.
		respond_to do |format|
			format.html
	    format.csv do
	    	response.headers['Content-Disposition'] = 'attachment; filename="GoodinRemoteEDSS.csv"'
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

	def bove2_results
		# V2 of Goodin/Bove that fixes pyramidal<->ambulation issues
		redirect_to notauthorized_path and return if redcap_data(params[:bove2API]).nil?

		# json string of redcap data
		@redcaps = redcap_data(params[:bove2API])
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
			bov = Bove2CalculationVarnames.new(record)
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

=begin
		edss = calc.edss_histogram(calc.data_set)
		sfs = calc.sfs_histogram(calc.data_set)
		ai = calc.ai_histogram(calc.data_set)
		ids = calc.record_ids(calc.data_set)

		@csv_string = 	CSV.generate do |csv|
			csv << ["record_id", "first_name", "last_name", "sfs", "edss", "aI", "nrs", "mds", "Ambulation", "Cerebellar", "Brainstem", "Sensory", "Bowel/Bladder", "Vision", "Cerebral", "Pyramidal","a1","a21",
			"a22","a23","a24","a1","a21","a22","a23","a24","f2a","f2b","f2c","f2d","bal","b3","f1fr","f1fl","f4fr","frfl","b1","f2s","b2","b4","f4a","f4b","f4c","f4d","f5ta","f6a","f6b","f7t","c1","f1a","f1b","f1c","f1d","f8a","f8b","f8c","f8d"]
		end

			ids.each do |participant|
				csv << participant.values
			end
		end
=end
=begin
		respond_to do |format|
			format.html do
				puts "HTML!"
			end
			format.csv do
				response.headers['Content-Disposition'] = 'attachment; filename="BoveV2RemoteEDSS.csv"'
				render :csv => csv_string
			end
=end

=begin
		respond_to do |format|
			format.html
			format.csv {
			send_data redcaps_hash,
								filename: "Bove2.csv",
								type: 'text/csv; charset=utf-8'
			}
		end
=end

	end

	private

	def redcap_data(key)
		# Function that calls to the redcap db for data.
		url = URI.parse("https://redcap.ucsf.edu/api/")
		post_args = {
			'token' => key,
			'content' => 'record',
			'format' => 'json',
			'type' => 'flat'
		}
		request= Net::HTTP.post_form(url, post_args)
		request.body
	end

end
