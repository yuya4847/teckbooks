class CreateNotification < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.integer :visitor_id
      t.integer :visited_id
      t.integer :review_id
      t.integer :comment_id
      t.string :action
      t.boolean :checked, default: false, null: false
    end
  end
end
