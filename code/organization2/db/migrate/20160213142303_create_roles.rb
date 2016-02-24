class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles, id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
      t.string :name
      t.uuid :parent_role_id

      t.timestamps null: false
    end
  end
end
