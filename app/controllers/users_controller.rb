class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update]
  before_action :find_user, only: %i[edit update]
  before_action :authorize_user!, only: %i[edit update]

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, { status: 303, notice: 'User Created Successfully' }
    else
      flash.alert = @user.errors.full_messages.join(', ')
      render :new, status: 303
    end
  end

  def edit; end

  def update
    if @user&.update user_params.except(:password, :password_confirmation)
      redirect_to root_path, { status: 303, notice: 'User updated successfully' }
    else
      flash.alert = @user.errors.full_messages.join(', ')
      render :edit, status: 303
    end
  end

  private

  def find_user
    @user = User.find_by_id(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation
    )
  end

  def authorize_user!
    redirect_to root_path, { status: 303, alert: 'Not authorized' } unless can? :crud, @user
  end
end
