class CreateTagRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :tag_relationships do |t|
      t.integer :review_id, null: false
      t.integer :tag_id, null: false

      t.timestamps
    end
  end
end
