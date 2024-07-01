class UsersController < ApplicationController
  before_action :load_user, only: %i(show)

  def index
    @pagy, @users = pagy User.all_except(current_user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      reset_session
      log_in @user
      flash[:success] = "Sign up success"

      redirect_to @user, status: :see_other
    else
      render :new, status: :unprocessable_content
    end
  end

  def show
    @pagy, @posts = pagy @user.posts.newest
  end

  private

  def user_params
    params.require(:user)
          .permit :name, :email, :password, :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = "User not found"
    redirect_to root_url
  end
end
