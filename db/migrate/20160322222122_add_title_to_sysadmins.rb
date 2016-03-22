class AddTitleToSysadmins < ActiveRecord::Migration
  def change
  	add_column :sysadmins, :title, :string 
  end
end
