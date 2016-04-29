class CreateTracVisits < ActiveRecord::Migration
  def change
    create_table :trac_visits do |t|
    	t.belongs_to :myo_participant

    	t.date :visit_date
    	

      t.timestamps
    end
  end
end
