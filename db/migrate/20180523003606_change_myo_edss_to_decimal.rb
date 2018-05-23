class ChangeMyoEdssToDecimal < ActiveRecord::Migration[5.2]
  def change
    change_column :trac_visits, :goodin_edss, :decimal
  end
end
