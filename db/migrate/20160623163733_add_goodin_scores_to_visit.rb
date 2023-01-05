class AddGoodinScoresToVisit < ActiveRecord::Migration[7.0]
  def change
  	add_column :trac_visits, :goodin_sfs, :integer
  	add_column :trac_visits, :goodin_ai, :integer
  	add_column :trac_visits, :goodin_nrs, :integer
  	add_column :trac_visits, :goodin_mds, :integer
  end
end
