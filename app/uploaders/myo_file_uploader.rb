class MyoFileUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    # Tells where to store the data uploads. Note, this information does not contain PHI and probably shouldn't 
    # considering it's stored within the root directory, unprotected
    visit_date = TracVisit.find(model.trac_visit.id).visit_date 
    participant_id = TracVisit.find(model.trac_visit.id).myo_participant_id
    "#{Rails.root}/myo/myo_data/#{visit_date}/#{participant_id}"
  end
end
