class CreateMyoParticipants < ActiveRecord::Migration[7.0]
  def change
    create_table :myo_participants do |t|
    	t.integer :participant_id
    	t.integer :tracms_myo_id
    	t.string :name
    	t.date :scheduled_date
    	t.date :exam_date
    	t.boolean :myo_visit
    	t.boolean :redcap_intake_q
    	t.boolean :redcap_ms_info
    	t.boolean :redcap_whodas
    	t.boolean :redcap_health_intake
    	t.string :mrn

      t.timestamps
    end
  end
end
