class CreateRules < ActiveRecord::Migration[6.0]
  def change
    create_table :rules do |t|
      t.integer :user_id
      t.string :rule_name, default: "general", null: false

      t.timestamps
    end
  end
end
