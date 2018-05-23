class ChangeMyoPhysEdssToDecimal < ActiveRecord::Migration[5.2]
  def change
    change_column :trac_visits, :physician_edss, :decimal
  end
end
