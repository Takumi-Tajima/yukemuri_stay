class My::PastReservations::ReviewsController < My::PastReservations::ApplicationController
  def new
    @review = @reservation.build_review
  end

  def create
    @review = @reservation.build_review(review_params)
    @review.user = current_user

    if @review.save
      redirect_to my_past_reservation_path(@reservation), notice: t('controllers.created')
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def review_params
    params.expect(review: %i[rating comment])
  end
end
