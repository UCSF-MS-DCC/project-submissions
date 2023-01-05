class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
    	t.string :title
    	t.string :author
    	t.text :project_description
    	t.text :data_description
    	t.text :data_frequency
    	
      t.timestamps
    end
  end
end
