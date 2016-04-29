json.array!(@myo_files) do |myo_file|
  json.extract! myo_file, :id, :trac_visit_id, :file
  json.url myo_file_url(myo_file, format: :json)
end
