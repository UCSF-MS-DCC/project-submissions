class EdssController < ApplicationController
	before_action :authenticate_user!
	authorize_resource :class => false
	respond_to :html, :csv

	def goodin
	end		

	def bove
	end

	def goodin_calculate
		data = {}
		calc = GoodinCalculation.new(JSON.parse(redcap_data(params[:goodinAPI])))
		edss = calc.edss_histogram(calc.data_set)
		sfs = calc.sfs_histogram(calc.data_set)
		ai = calc.ai_histogram(calc.data_set)
		ids = calc.record_ids(calc.data_set)

		csv_string = CSV.generate do |csv|
			csv << ["record_id", "first_name", "last_name", "sfs", "edss", "aI", "nrs", "mds"]
			ids.each do |participant|
				puts participant
				puts "****"
				csv << participant.values
			end
		end		
		respond_to do |format|
			format.html
	    format.csv do
	    	response.headers['Content-Disposition'] = 'attachment; filename="GoodinRemoteEDSS.csv"'
	     	render :csv => csv_string
	   	end
	  end
	end

	def bove_calculate
		data = {}
		calc = BoveCalculation.new(JSON.parse(redcap_data(params[:boveAPI])))
		edss = calc.edss_histogram(calc.data_set)
		sfs = calc.sfs_histogram(calc.data_set)
		ai = calc.ai_histogram(calc.data_set)
		ids = calc.record_ids(calc.data_set)		

		csv_string = 	CSV.generate do |csv|
			csv << ["record_id", "first_name", "last_name", "sfs", "edss", "aI", "nrs", "mds"]
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
