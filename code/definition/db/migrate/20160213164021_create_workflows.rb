class CreateWorkflows < ActiveRecord::Migration
  def change
    create_table :workflows, id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
      t.string :name
      t.uuid :user_id

      t.timestamps null: false
    end
  end
end
