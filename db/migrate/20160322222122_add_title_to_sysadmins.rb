class AddTitleToSysadmins < ActiveRecord::Migration[7.0]
  def change
  	add_column :sysadmins, :title, :string 
  end
end
