class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @idea = Idea.find params[:idea_id]
    @review = Review.new review_params
    @review.user = current_user
    @review.idea = @idea
    if @review.save
      redirect_to idea_path(@idea), { status: 303, notice: 'Review created successfully' }
    else
      @reviews = @idea.reviews.order(created_at: :desc)
      flash.alert = @review.errors.full_messages.join(', ').gsub('Body', 'Review')
      render 'ideas/show', status: 303
    end
  end

  def destroy
    @review = Review.find params[:id]
    if can? :destroy, @review
      @review.destroy
      redirect_to idea_path(@review.idea), { status: 303, alert: 'Review deleted successfully' }
    else
      redirect_to root_path, { status: 303, alert: 'Not authorized' }
    end
  end

  private

  def review_params
    params.require(:review).permit(:body)
  end
end
