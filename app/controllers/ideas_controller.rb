class IdeasController < ApplicationController
  before_action :find_idea, only: %i[show edit update destroy]

  def index
    @ideas = Idea.order(updated_at: :desc)
  end

  def new
    @idea = Idea.new
  end

  def create
    @idea = Idea.new idea_params
    if @idea.save
      redirect_to idea_path(@idea), { status: 303, notice: 'Idea created successfully' }
    else
      flash.alert = @idea.errors.full_messages.join(', ')
      render :new, status: 303
    end
  end

  def show; end

  def edit; end

  def update
    if @idea.update idea_params
      redirect_to idea_path(@idea), { status: 303, notice: 'Idea updated successfully' }
    else
      flash.alert = @idea.errors.full_messages.join(', ')
      render :edit, status: 303
    end
  end

  def destroy
    @idea.destroy
    redirect_to root_path, { status: 303, notice: 'Idea deleted successfully' }
  end

  private

  def idea_params
    params.require(:idea).permit(:title, :description)
  end

  def find_idea
    @idea = Idea.find(params[:id])
  end
end
