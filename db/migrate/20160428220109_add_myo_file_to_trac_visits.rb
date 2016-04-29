class AddMyoFileToTracVisits < ActiveRecord::Migration
  def change
    add_column :trac_visits, :myo_file, :string
  end
end
