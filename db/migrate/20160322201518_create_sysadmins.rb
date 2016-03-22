class CreateSysadmins < ActiveRecord::Migration
  def change
    create_table :sysadmins do |t|
    	t.text :content

      t.timestamps
    end
  end
end
