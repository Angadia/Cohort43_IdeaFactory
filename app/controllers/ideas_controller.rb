class IdeasController < ApplicationController
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

  private

  def idea_params
    params.require(:idea).permit(:title, :description)
  end
end
