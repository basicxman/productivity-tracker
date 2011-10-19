class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.date :date
      t.integer :user_id
      t.float :quota

      t.timestamps
    end
  end
end
