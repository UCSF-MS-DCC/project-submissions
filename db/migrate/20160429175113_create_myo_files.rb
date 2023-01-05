class CreateMyoFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :myo_files do |t|
      t.integer :trac_visit_id
      t.string :file

      t.timestamps
    end
  end
end
