# For more information on this model checkout the carrierwave gem.
class MyoFile < ApplicationRecord
	 mount_uploader :file, MyoFileUploader
	 belongs_to :trac_visit, optional: true
end
