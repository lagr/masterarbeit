class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
      t.string :first_name
      t.string :last_name
      t.uuid :role_id

      t.timestamps null: false
    end
  end
end
