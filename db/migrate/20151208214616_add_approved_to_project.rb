class AddApprovedToProject < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :approved, :boolean, :default => false
  end
end
