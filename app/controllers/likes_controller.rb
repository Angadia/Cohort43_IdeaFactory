class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_idea, only: [:create]
  before_action :authorize_user!, only: [:create]

  def create
    like = Like.new user: current_user, idea: @idea
    if like.save
      redirect_to root_path, { status: 303, notice: 'Idea liked' }
    else
      redirect_to root_path, { status: 303, alert: like.errors.full_messages.join(', ') }
    end
  end

  def destroy
    like = current_user.likes.find params[:id]
    if can? :destroy, like
      like.destroy
      redirect_to root_path, { status: 303, notice: 'Idea unliked' }
    else
      redirect_to root_path, { status: 303, alert: 'Not authorized' }
    end
  end

  private

  def find_idea
    @idea = Idea.find params[:idea_id]
  end

  def authorize_user!
    redirect_to idea_path(@idea), { status: 303, alert: 'Not authorized' } unless can?(:like, @idea)
  end
end
