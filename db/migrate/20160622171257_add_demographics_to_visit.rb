class AddDemographicsToVisit < ActiveRecord::Migration[7.0]
  def change
  	add_column :trac_visits, :physician_edss, :integer
  	add_column :trac_visits, :goodin_edss, :integer
  end
end
