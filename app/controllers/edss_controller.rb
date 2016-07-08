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
