# Controller that handles both goodin and bove EDSS pages.

=begin
# Can copy + paste + transpose these to display on Excel above columnar scores
1. Which of the following best describes your ability to walk (circle one)  1.  I can walk without any problem.  2.  I have some difficulties with walking but I can walk without aid for 500 meters or more. (i.e.,  approximately the length of 5 football fields or one third of a mile).  3.  I have some difficulties with walking but I can walk without aid for about 300 meters (i.e.,  approximately the length of 3 football fields or one fifth of a mile).  4.  I have some difficulties with walking but I can walk without aid for about 200 meters (i.e.,  approximately the length of 2 football fields or one tenth of a mile).  5.  I have some difficulties with walking but I can walk without aid for about 100 meters (i.e.,  approximately the length of 1 football fields or 300 feet).  6.  I require an aid (e.g. cane, crutch, walker or another person) to walk 100 meters (300 feet).  7.  I require an aid (e.g. cane, crutch, walker or another person) to walk 20 meters (60 feet).  8.  I require an aid (e.g. cane, crutch, walker or another person) to walk 8 meters (25 feet).  9.  I use a wheelchair for almost all activities.  10.  I am confined to bed most of the time.
2. When you move about, what percentage of the time do you: walk without aid?
2. When you move about, what percentage of the time do you: use a cane, a single crutch, or hold onto another person?
2. When you move about, what percentage of the time do you: use a walker or other bilateral support?
2. When you move about, what percentage of the time do you: use a wheel chair?
3. Which of the following best describes your functional abilities?  1.  I am able to carry out my usual daily activities without limitation.  2.  I have limitations but can carry out most of my usual daily activities, even if I may require some special provisions such as altered work hours or naps.  3.  I am able to carry out about only half of my usual daily activities even with special provisions.  4.  I am severely limited in my ability to carry out my usual daily activities.  5.  I require assistance with even my basic self care activities such as dressing, bathing, transferring and going to the bathroom.
4. In my right arm, my strength is:  0, 1. Normal  1, 2. Mildly impaired  2, 3. Moderately impaired  3, 4. Severely impaired
4. In my left arm, my strength is:  0, 1. Normal  1, 2. Mildly impaired  2, 3. Moderately impaired  3, 4. Severely impaired
4. In my right leg, my strength is:  0, 1. Normal  1, 2. Mildly impaired  2, 3. Moderately impaired  3, 4. Severely impaired
4. In my left leg, my strength is:  0, 1. Normal  1, 2. Mildly impaired  2, 3. Moderately impaired  3, 4. Severely impaired
4b. When you are laughing or furrowing your eyebrows, does the left side of your face move normally and does your left eye close completely? 0, 1. Yes.  1, 2. No, my left face is slightly weak when laughing or furrowing eyebrows.  2, 3. No, my left face is definitely asymmetric face at rest and the closure of my left eye is impaired.  3, 4. No, lid closure of my left eye is impossible
4a. When you are laughing or furrowing your eyebrows, does the right side of your face move normally and does your right eye close completely? 0, 1. Yes.  1, 2. No, my right face is slightly weak when laughing or furrowing eyebrows.  2, 3. No, my right face is definitely asymmetric face at rest and the closure of my right eye is impaired.  3, 4. No, lid closure of my right eye is impossible
5. In my right arm, my sensation is:  0, 1. Normal  1, 2. Mildly impaired  2, 3. Moderately impaired  3, 4. Severely impaired
5. In my left arm, my sensation is:  0, 1. Normal  1, 2. Mildly impaired  2, 3. Moderately impaired  3, 4. Severely impaired
5. In my right leg, my sensation is:  0, 1. Normal  1, 2. Mildly impaired  2, 3. Moderately impaired  3, 4. Severely impaired
5. In my left leg, my sensation is:  0, 1. Normal  1, 2. Mildly impaired  2, 3. Moderately impaired  3, 4. Severely impaired
5b. When touching the left side of your face, has your sensation changed recently? 0, 1. No, I have normal sensation in my left face  1, 2. Yes, I have slight or mild numbness when touching some parts of my left face  2, 3. Yes, I have moderately or markedly decreased sensation in parts of my left face, or pain attacks in the right face  3, 4. Yes, I can't feel touch at all, in the entire left face
5a. When touching the right side of your face, has your sensation changed recently? 0, 1. No, I have normal sensation in my right face  1, 2. Yes, I have slight or mild numbness when touching some parts of my right face  2, 3. Yes, I have moderately or markedly decreased sensation in parts of my right face, or pain attacks in the right face  3, 4. Yes, I can't feel touch at all, in the entire right face
6. My corrected vision for my right eye is:  0, 1. Normal  1, 2. Mildly impaired  2, 3. Moderately impaired  3, 4. Severely impaired
6. My corrected vision for my left eye is:  0, 1. Normal  1, 2. Mildly impaired  2, 3. Moderately impaired  3, 4. Severely impaired
7. Do you have double vision when looking at something? 0, 1. No, I don't see double  1, 2. Yes, I have double vision when looking in some directions but it does not affect my quality of life  2, 3. Yes, I almost always have double vision, one eye needs to be covered, it does affect my quality of life,  3, 4. Yes, I have complete loss of movement in one or more directions of gaze, in one or both of my eyes
8. In my right arm, my coordination is:  0, 1. Normal  1, 2. uncoordinated  2, 3. Moderately uncoordinated  3, 4. Severely uncoordinated
8. In my left arm, my coordination is:  0, 1. Normal  1, 2. uncoordinated  2, 3. Moderately uncoordinated  3, 4. Severely uncoordinated
8. In my right leg, my coordination is:  0, 1. Normal  1, 2. uncoordinated  2, 3. Moderately uncoordinated  3, 4. Severely uncoordinated
8. In my left leg, my coordination is:  0, 1. Normal  1, 2. uncoordinated  2, 3. Moderately uncoordinated  3, 4. Severely uncoordinated
9. Can you speak clearly? 0, 1. Yes  1, 2. No, I have some difficulties in speaking (dysarthria), noticed by others when I am talking  2, 3. No, my difficulty speaking (dysarthria) is such that it impairs my conversation  3, 4. No, my speech is incomprehensible or absent
10. Which of the following best describes your balance?  0, 1. I have no difficulty with my balance  1, 2. I have mild difficulty with my balance  2, 3. I have moderate difficulty with my balance  3, 4. I have severe difficulty with my balance
11. In my right arm, my spasticity is:  0, 1. None  1, 2. Mild  2, 3. Moderate  3, 4. Severe
11. In my left arm, my spasticity is:  0, 1. None  1, 2. Mild  2, 3. Moderate  3, 4. Severe
11. In my right leg, my spasticity is:  0, 1. None  1, 2. Mild  2, 3. Moderate  3, 4. Severe
11. In my left leg, my spasticity is:  0, 1. None  1, 2. Mild  2, 3. Moderate  3, 4. Severe
12. Which of the following best describes your cognitive (thinking) ability?  1, 1. I have had no change in my cognitive (thinking) abilities.  2, 2. I have had a mild impairment of my cognitive (thinking) abilities.  3, 3. I have had a moderate impairment of my cognitive (thinking) abilities.  4, 4. I have had a severe impairment of my cognitive (thinking) abilities  5, 5. I am unable to handle my affairs because of my severe cognitive problems.
13. Which of the following best describes your mood since getting MS?  1, 1. My mood has been unchanged since getting MS.  2, 2. I have become depressed or more depressed since getting MS.  3, 3. Although I am not pleased to have MS, I have become a more cheerful person since getting it.
14. Do you have difficulties with your swallowing? 0, 1. No  1, 2. Yes, I have mild difficulty with swallowing thin liquids and/or solid foods  2, 3. Yes, I have moderate difficulty with swallowing thin liquids and/or solid foods  3, 4. Yes, I require a pureed diet to eat or I can't swallow
15. In regards to my bowel function:  1, 1. I have normal function.  2, 2. I have urgency/ I have constipation  3, 3. I have frequency(i.e., I go unusually often).  4, 4. I have hesitancy (i.e., I have difficult getting started).  5, 5. I am occasionally incontinent.  6, 6. I am frequently incontinent ( weekly or more often bus less than daily).  7, 7. I am frequently incontinent (daily or more often).  8, 8. I require intermittent catheterization.  9, 9. I require an indwelling catheter.
15. In regards to my bladder function:  1, 1. I have normal function.  2, 2. I have urgency/ I have constipation  3, 3. I have frequency(i.e., I go unusually often).  4, 4. I have hesitancy (i.e., I have difficult getting started).  5, 5. I am occasionally incontinent.  6, 6. I am frequently incontinent ( weekly or more often bus less than daily).  7, 7. I am frequently incontinent (daily or more often).  8, 8. I require intermittent catheterization.  9, 9. I require an indwelling catheter.
16. Do you experience dizziness or vertigo (i.e. a sense or a feeling of motion)? If so, how severe is the vertigo or dizziness (i.e. a sense or a feeling of motion)?  0, 1. I do not experience vertigo or dizziness.  1, 2. Mild dizziness  2, 3. Moderate dizziness  3, 4. Severed dizziness
17. Do you have any problems with your hearing? 0, 1. No  1, 2. Yes, my hearing is slightly or mildly decreased on one side  2, 3. Yes, my hearing is moderately or severely decreased on one side  3, 4. Yes, I can't hear in either ear ; I am effectively deaf
=end

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
		# Shows bove2 view, which is just an API key submission form
	end

	def bove3
		# Same as 'goodin' and 'bove' method with bove3 used.
		# Shows bove3 view, which is just an API key submission form
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

	def bove3_results
		# V3 of Goodin/Bove that expands on V2 w/

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
