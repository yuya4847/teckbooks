class CreateRecommends < ActiveRecord::Migration[6.0]
  def change
    create_table :recommends do |t|
      t.integer :recommend_user_id
      t.integer :recommended_user_id
      t.integer :review_id

      t.timestamps
    end
  end
end
