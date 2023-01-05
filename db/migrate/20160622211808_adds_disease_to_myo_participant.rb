class AddsDiseaseToMyoParticipant < ActiveRecord::Migration[7.0]
  def change
  	add_column :myo_participants, :case_or_control, :string
  	add_column :myo_participants, :onset, :string
  	add_column :myo_participants, :disease_type, :string
  end
end
