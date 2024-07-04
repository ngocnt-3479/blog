class Api::UsersController < Api::ApplicationController
  before_action :load_user, only: %i(show)
  before_action :authenticate_user, only: %i(index show)

  def index
    @pagy, @users = pagy User.all_except(@current_user)
    serialized_users = ActiveModelSerializers::SerializableResource.new(@users,
                                                                        each_serializer: UserSerializer)
    render json: {users: serialized_users,
                  message: "Get all users success"},
           status: :ok
  end

  def create
    @user = User.create user_params
    if @user.save
      @token = encode_token(user_id: @user.id)
      render json: {
        user: UserSerializer.new(@user),
        token: @token,
        message: "Sign up success"
      }, status: :created
    else
      render json: {message: "Sign up failure"},
             status: :unprocessable_entity
    end
  end

  def show
    render json: {user: UserSerializer.new(@user),
                  message: "Get post success"},
           status: :ok
  end

  private

  def user_params
    params.require(:user)
          .permit :name, :email, :password, :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    render json: {message: "User not found"}, status: :not_found
  end
end
