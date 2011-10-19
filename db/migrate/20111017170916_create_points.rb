class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.integer :day_id
      t.float :value
      t.integer :task_id

      t.timestamps
    end
  end
end
