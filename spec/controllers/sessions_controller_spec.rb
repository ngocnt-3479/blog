require "rails_helper"
require "shared_examples"
include SessionsHelper
RSpec.describe SessionsController, type: :controller do
  describe "GET new" do
    before do
      get :new
    end

    it "render signup page" do
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    let(:user) {create(:user)}

    context "success login" do
      before do
        post :create, params: {session: {email: user.email, password: user.password}}
      end

      it "should update session with user_id" do
        expect(session[:user_id]).to eq(user.id)
      end

      it_behaves_like "redirect to user page"
    end

    context "failure when wrong email or password" do
      before do
        post :create, params: {session: {email: user.email, password: "wrong_password"}}
      end

      it "show flash invalid email or password" do
        expect(flash[:danger]).to eq("Invalid email or password")
      end

      it "render login page again" do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "DELETE destroy" do
    let(:user) {create(:user)}

    context "logout with logged in" do
      before do
        log_in user
        delete :destroy
      end

      it "clear session" do
        expect(session[:user_id]).to be_nil
      end

      it_behaves_like "redirect to home page"
    end

    context "logout without logged in" do
      before do
        delete :destroy
      end

      it_behaves_like "redirect to home page"
    end
  end
end
