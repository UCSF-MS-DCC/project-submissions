class CreateSysadmins < ActiveRecord::Migration[7.0]
  def change
    create_table :sysadmins do |t|
    	t.text :content

      t.timestamps
    end
  end
end
