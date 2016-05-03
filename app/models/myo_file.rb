class MyoFile < ActiveRecord::Base
	 mount_uploader :file, MyoFileUploader
	 belongs_to :trac_visit
end
