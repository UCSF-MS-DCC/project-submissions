class TracVisit < ApplicationRecord
	belongs_to :myo_participant, optional: true
	has_many :myo_files
  accepts_nested_attributes_for :myo_files
end
