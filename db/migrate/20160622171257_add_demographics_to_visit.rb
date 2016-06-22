class AddDemographicsToVisit < ActiveRecord::Migration
  def change
  	add_column :trac_visits, :physician_edss, :integer
  	add_column :trac_visits, :goodin_edss, :integer
  end
end
