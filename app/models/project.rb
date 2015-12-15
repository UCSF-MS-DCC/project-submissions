class Project < ActiveRecord::Base
	include Humanizer
	# require_human_on :create

	validates :title, presence: true
	validates :author, presence: true
	validates :project_description, presence: true
	# validates :data_description, presence: true
	# validates :data_frequency, presence: true
end
