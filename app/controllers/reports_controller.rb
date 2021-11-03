class ReportsController < ApplicationController
  def create
    Report.create(user_id: current_user.id, review_id: params[:review_id])
    @review = Review.find(params[:review_id])
    @report_reviews = Review.find_by_sql('
      SELECT *
      FROM reviews
      WHERE reviews.id = (
        SELECT review_id
          FROM reports
          GROUP BY reports.review_id
          HAVING (COUNT(*) >= 5)
      )
    ')
    if @report_reviews != []
      @report_reviews.each do |report_review|
        report_review.destroy
      end
      @delete_review = "on"
    else
      @delete_review = nil
    end
    render :index
  end
end
