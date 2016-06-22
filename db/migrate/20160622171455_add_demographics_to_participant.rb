class AddDemographicsToParticipant < ActiveRecord::Migration
  def change
  	add_column :myo_participants, :dob, :string
  	add_column :myo_participants, :email, :string
  	add_column :myo_participants, :sex, :string
  end
end
