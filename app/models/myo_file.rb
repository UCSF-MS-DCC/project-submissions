# For more information on this model checkout the carrierwave gem.
class MyoFile < ActiveRecord::Base
	 mount_uploader :file, MyoFileUploader
	 belongs_to :trac_visit
end
