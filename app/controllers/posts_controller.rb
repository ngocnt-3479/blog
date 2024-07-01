class PostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :load_post,
                only: %i(update destroy)
  before_action :correct_user, only: %i(update destroy)

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

  def load_post
    @post = Post.find_by id: params[:id]

    return if @post

    flash[:danger] = "Not found post"
    redirect_to root_url
  end
end
