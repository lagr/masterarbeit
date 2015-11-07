class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid, default: "uuid_generate_v4()", force: true  do |t|
      t.string :first_name
      t.string :last_name
      t.timestamps null: false
    end
  end
end
