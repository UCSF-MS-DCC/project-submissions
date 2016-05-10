class MyoParticipant < ActiveRecord::Base
	has_many :trac_visits

	validates :tracms_myo_id,  uniqueness: true
	validates :scheduled_date, presence: true

	after_create :create_visit

	def create_visit
		self.trac_visits.create(visit_date: self.scheduled_date)
	end
end
