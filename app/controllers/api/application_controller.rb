class Api::ApplicationController < ActionController::API
  include Pagy::Backend

  private

  def encode_token payload
    JWT.encode(payload, "salt")
  end

  def decode_token
    auth_header = request.headers["Authorization"]
    return nil unless auth_header

    token = auth_header.split(" ")[1]
    begin
      JWT.decode(token, "salt", true, algorithm: "HS256")
    rescue JWT::DecodeError
      nil
    end
  end

  def authenticate_user
    user_id = decode_token[0]["user_id"] if decode_token
    @current_user = User.find_by(id: user_id) if user_id

    return if @current_user

    render json: {message: "Please log in"},
           status: :unauthorized
  end
end
