class PostsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, except: :create

  def create
    @post = current_user.posts.build post_params
    @post.image.attach params.dig(:post, :image)
    flash.now[:success] = "Create post successfully" if @post.save
    respond_to(&:js)
  end

  def update
    flash.now[:success] = "Update post successfully" if @post.update post_params
    respond_to(&:js)
  end

  def destroy
    if @post.destroy
      flash[:success] = "Delete post successfully"
    else
      flash[:danger] = "Delete post failed"
    end
    redirect_to request.referer || root_url
  end

  def update_status
    case params[:status].to_sym
    when :public
      flash.now[:success] = "Change status post to public success"
      @post.update_attribute(:isPrivate, false)
    when :private
      flash.now[:success] = "Change status post to private success"
      @post.update_attribute(:isPrivate, true)
    else
      flash[:danger] = "Change status post failed"
      redirect_to request.referer || root_url
    end
    respond_to(&:js)
  end

  private

  def post_params
    params.require(:post).permit :content, :image
  end

  def correct_user
    @post = current_user.posts.find_by id: params[:id]

    return if @post

    flash[:danger] = "Post invalid"
    redirect_to request.referer || root_url
  end
end
