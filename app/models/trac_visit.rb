class TracVisit < ActiveRecord::Base
	belongs_to :myo_participant

	mount_uploader :myo_file, MyoFileUploader
end
