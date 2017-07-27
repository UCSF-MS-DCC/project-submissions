class MyoParticipant < ActiveRecord::Base
	has_many :trac_visits

	validates :tracms_myo_id,  uniqueness: true
	validates :scheduled_date, presence: true

	after_create :create_visit

	def create_visit
		# Method for automatically creating a visit once an individual is created. Called from a active record callback (see above)
		self.trac_visits.create(visit_date: self.scheduled_date)
	end

	def self.update_db_from_redcap
		# little bit of a beast method. Calls the redcap API and populates the DB with redcap information. A little costly because it happens
		# on every index.html page load but since this page isn't high traffic it should be OK. Otherwise we would rely on the coordinator
		# to manually import and that could lead to data issues.
		@captured_participants= []
		@uncaptured_visits = []
		url = URI.parse(ENV['myo_api_url'])

		post_args = {
			'token' => ENV['myo_api_token'],
			'content' => 'record',
			'rawOrLabel' => 'label',
			'format' => 'json',
			'type' => 'flat',
			'rawOrLabelHeaders' => 'raw'
		}

=begin
		REDCap record_id = REDCap participant_id is "tracms_myo_id" which is 1001+, as assigned by coordinator
		REDCap pt_id  is	"tracms_myo_study_id_number which is the  redcap visit id (survey id)
		REDCap enrollment_date which is consent date
		Below, data = redcap records: 1 per visit.  goodin fields are .zipped (joined) onto it
		physician = data w/o the goodin fields
		myo_participant = visit where tracms_myo_id = physician record id
=end

		request= Net::HTTP.post_form(url, post_args)
		data = JSON.parse(request.body)
		goodin_scores = GoodinCalculation.new(data)

		# You're zipping together the goodin scores along with the redcap information per individual. That way when we loop through each individual it's a lot easier to
		# update the db.
		data.zip(goodin_scores.data_set).each do |physician, goodin|

			myo_participant = MyoParticipant.where(tracms_myo_id: physician["record_id"].to_i).first
			if myo_participant

				# Updating an individual MyoParticipant model.
				myo_participant.update_attributes(email: physician["email"], sex: physician["sex"] , dob: physician["dob"])
				if physician["date_enrolled"] != ""
					(1..8).each do |x|
						# This is called because the way the raw data is imported from redcap you don't necessary know the disease of the individual because the data is raw.
						# Thus, you need to call the 'convert_to_disease' method which will translate the number to a disease.
						if physician["patientreportdx___" + x.to_s] == "Checked"
							@disease_number = x.to_s
						end
					end
					if physician["ms_or_hc"] == "MS"
						# If the individual is a healthy control, you don't want to run the goodin algorithm or include a few of the other fields.
						# Get the coordinator-entered visit with a visit_date within 60 days of the visit consent date, and update the EDSS fields:
						# Don't do this if visit has not been entered, or nomethoderror for update_attributes on nil will be raised.

						if @visit = myo_participant.trac_visits.where(visit_date: DateTime.parse(physician["date_enrolled"])-60.days..DateTime.parse(physician["date_enrolled"])+60.days).first
							@visit.update_attributes(physician_edss: physician["edss"], goodin_edss: goodin[:edss], goodin_sfs: goodin[:sfs], goodin_ai: goodin[:aI], goodin_nrs: goodin[:nrs], goodin_mds: goodin[:mds])
						else
							@uncaptured_visits.push(physician["record_id"] + ": " + physician["date_enrolled"])
						end
						myo_participant.update_attributes(onset: physician["dateonset"], case_or_control: physician["ms_or_hc"], disease_type: convert_to_disease(@disease_number))
					else
						myo_participant.trac_visits.where(visit_date: DateTime.parse(physician["date_enrolled"])-60.days..DateTime.parse(physician["date_enrolled"])+60.days).first.update_attributes(physician_edss: "", goodin_edss: "", goodin_sfs: "", goodin_ai: "", goodin_nrs: "", goodin_mds: "")
						myo_participant.update_attributes(onset: "", case_or_control: physician["ms_or_hc"], disease_type: "")
					end
				else
				end
			else
				# note: these are not actually captured...these are the record_ids that are not yet in the db!
				@captured_participants.push(physician['record_id'])
			end
		end		
		[@captured_participants, @uncaptured_visits]
	end

	def self.convert_to_disease(number)
		# Basically converting the raw data for disease type. 
		codebook = {"1"=>"RR", "2"=>"SP", "3"=>"PR", "4"=>"Optic Neuritis", "5"=>"Transverse Myelitis", "6"=>"CIS", "7"=>"RIS", "8"=>"Demyelinating disease not otherwise specified"}
		codebook[number]
	end	

	def self.prepare_completed_csv
		# Preparing the CSV for download of redcap data along with goodin edss scores
		download_string = CSV.generate do |csv|
			csv << TracVisit.attribute_names.prepend("tracms_myo_id") - ["updated_at"]
			TracVisit.all.each do |visit|
				csv << visit.attributes.values.prepend(visit.myo_participant.tracms_myo_id) - [visit.updated_at]
			end
		end
	end
end
