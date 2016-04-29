class MyoParticipant < ActiveRecord::Base
	validates :participant_id, presence: true, uniqueness: true
	validates :tracms_myo_id, presence: true, uniqueness: true

	has_many :trac_visits
end
