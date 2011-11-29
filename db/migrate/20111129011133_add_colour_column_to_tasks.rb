class AddColourColumnToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :colour, :string, :default => "c1"
  end
end
