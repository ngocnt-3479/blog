class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper

  private

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = "Please login"
    redirect_to login_url
  end
end
