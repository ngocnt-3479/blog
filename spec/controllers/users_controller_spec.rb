require "rails_helper"
require "shared_examples"

RSpec.describe UsersController, type: :controller do
  describe "GET new" do
    before do
      get :new
    end

    it "create a new empty user" do
      expect(assigns(:user)).to be_a_new(User)
    end

    it "render signup page" do
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    context "success create" do
      let(:valid_user_params) {attributes_for :user}

      before do
        post :create, params: {user: valid_user_params}
      end

      it "should have a new user" do
        expect(User.where(id: assigns(:user).id)).to exist
      end

      it "show flash sign up success" do
        expect(flash[:success]).to eq("Sign up success")
      end
    end

    context "failure create" do
      let(:invalid_user_params) {attributes_for(:user, name: "")}

      before do
        post :create, params: {user: invalid_user_params}
      end

      it "have errors" do
        expect(assigns(:user).errors.count).not_to eq(0)
      end

      it "render signup page" do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET show" do
    let(:user) {create(:user)}

    context "success show" do
      before do
        get :show, params: {id: user.id}
      end

      it "assign @user" do
        expect(assigns(:user)).to eq(user)
      end

      it "renders the show template" do
        expect(response).to render_template("show")
      end
    end

    context "fail when user not found" do
      before do
        get :show, params: {id: -1}
      end

      it_behaves_like "show flash user not found"

      it_behaves_like "redirect to home page"
    end
  end
end
