class ReportsController < ApplicationController
  def create
    Report.create(user_id: current_user.id, review_id: params[:review_id])
    @review = Review.find(params[:review_id])
    @review.create_notification_report!(current_user)
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
      @is_delete_review = true
    else
      @is_delete_review = false
    end
    contents = { review_id: @review.id, is_delete_review: @is_delete_review }
    render json: contents
  end
end
