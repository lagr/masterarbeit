class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments, id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
      t.uuid :activity_id
      t.uuid :assignable_id
      t.string :assignable_type

      t.timestamps null: false
    end
  end
end
