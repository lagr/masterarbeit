class AddWorkflows < ActiveRecord::Migration
  def change
    create_table :workflows, id: :uuid, default: "uuid_generate_v4()", force: true do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
