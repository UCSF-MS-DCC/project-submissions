class AddBiologicalDescriptionToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :biological_description, :text
  end
end
