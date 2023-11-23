class ReviewsController < ApplicationController
  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.player_id = current_player.id
    @review.game_id = params[:game_id]
    if @review.save
      redirect_to game_path(@review.game)
    else
      render :new_review, status: :unprocessable_entity
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
