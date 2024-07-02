class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_user, only: :create
  before_action :load_relationship, only: :destroy

  def create
    if current_user.follow(@user)
      flash.now[:success] = "Follow user successfully"
      respond_to(&:js)
    else
      flash.now[:danger] = "Follow user failed"
      redirect_to root_path
    end
  end

  def destroy
    @user = @relationship.followed
    if current_user.unfollow(@user)
      flash.now[:success] = "Unfollow user successfully"
      respond_to(&:js)
    else
      flash[:danger] = "Unfollow user failed"
      redirect_to root_path
    end
  end

  private

  def load_user
    @user = User.find_by id: params[:followed_id]

    return if @user

    flash[:danger] = "User not found"
    redirect_to root_path
  end

  def load_relationship
    @relationship = Relationship.find_by id: params[:id]

    return if @relationship

    flash[:danger] = "Relationship not found"
    redirect_to root_path
  end
end
