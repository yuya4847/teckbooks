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
        HAVING (COUNT(*) >= 1)
      )
    ')

    delete_reviews = Review.find(Report.group(:review_id).having('count(*) >= ?', 1).pluck(:review_id))

    delete_reviews2 = Review.find_by_sql('
      SELECT *
      FROM reviews AS T1
      JOIN
      (
        SELECT *
        FROM reports
        GROUP BY reports.review_id
        HAVING (COUNT(*) >= 1)
      ) T2
      ON T1.id = T2.review_id;
    ')

    sql = <<-"SQL"
    SELECT *
    FROM reviews AS T1
    JOIN
    (
      SELECT *
      FROM reports
      GROUP BY reports.review_id
      HAVING (COUNT(*) >= 1)
    ) T2
    ON T1.id = T2.review_id;
    SQL

    delete_reviews3 = ActiveRecord::Base.connection.execute(sql)


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
