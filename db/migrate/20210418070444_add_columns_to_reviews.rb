class AddColumnsToReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :reviews, :link, :string
  end
end
