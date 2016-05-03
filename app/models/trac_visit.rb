class TracVisit < ActiveRecord::Base
	belongs_to :myo_participant
	has_many :myo_files
  accepts_nested_attributes_for :myo_files
end
