class CreateBrowsingHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :browsing_histories do |t|
      t.integer :user_id
      t.integer :review_id

      t.timestamps
    end
  end
end
