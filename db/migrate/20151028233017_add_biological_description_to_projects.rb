class AddBiologicalDescriptionToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :biological_description, :text
  end
end
