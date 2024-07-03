class ReactionsController < ApplicationController
  before_action :logged_in_user
  before_action :load_post, only: :create
  before_action :load_reaction, only: :destroy

  def create
    if current_user.reaction(@post)
      respond_to(&:js)
    else
      flash.now[:danger] = "Reaction post failed"
      redirect_to root_path
    end
  end

  def destroy
    @post = @reaction.post
    if current_user.unreaction(@post)
      respond_to(&:js)
    else
      flash[:danger] = "Unreaction post failed"
      redirect_to root_path
    end
  end

  private

  def load_reaction
    @reaction = Reaction.find_by id: params[:id]

    return if @reaction

    flash[:danger] = "Reaction not found"
    redirect_to root_path
  end

  def load_post
    @post = Post.find_by id: params[:post_id]

    return if @post

    flash[:danger] = "Post not found"
    redirect_to root_url
  end
end
