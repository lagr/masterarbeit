class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers, id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
      t.string :name
      t.string :ip
      t.jsonb :server_configuration

      t.timestamps null: false
    end
  end
end
