class Api::ReactionsController < Api::ApplicationController
  before_action :authenticate_user
  before_action :load_post, only: :create
  before_action :load_reaction, only: :destroy

  def create
    if current_user.reaction(@post)
      render json: {message: "Create reaction success"}, status: :ok
    else
      render json: {message: "Create reaction failure"},
             status: :unprocessable_entity
    end
  end

  def destroy
    @post = @reaction.post
    if current_user.unreaction(@post)
      render json: {message: "Delete reaction success"}, status: :ok
    else
      render json: {message: "Delete reaction failure"},
             status: :bad_request
    end
  end

  private

  def load_reaction
    @reaction = Reaction.find_by id: params[:id]

    return if @reaction

    render json: {message: "Reaction not found"}, status: :not_found
  end

  def load_post
    @post = Post.find_by id: params[:post_id]

    return if @post

    render json: {message: "Post not found"}, status: :not_found
  end
end
