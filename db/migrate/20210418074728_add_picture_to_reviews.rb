class AddPictureToReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :reviews, :picture, :string
  end
end
