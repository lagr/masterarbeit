class CreateWorkflows < ActiveRecord::Migration
  def change
    create_table :workflows do |t|
      t.string :name
      t.uuid :user_id

      t.timestamps null: false
    end
  end
end
