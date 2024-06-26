require "rails_helper"
require "shared_examples"
include SessionsHelper

RSpec.describe PostsController, type: :controller do
  describe "POST create" do
    let(:user) {create :user}

    context "success create a post" do
      let(:vaild_post_params) {attributes_for(:post)}

      before do
        log_in user
        post :create, params: {post: vaild_post_params, user_id: user.id}, format: :js
      end

      it "should have a new post" do
        expect(Post.where(id: assigns(:post).id)).to exist
      end

      it "show flash create post pitch success" do
        expect(flash[:success]).to eq("Create post successfully")
      end
    end

    context "failure create a post" do
      let(:invalid_spost_params) {attributes_for(:post, content: nil)}

      before do
        log_in user
        post :create, params: {post: invalid_spost_params, user_id: user.id}, format: :js
      end

      it "have errors" do
        expect(assigns(:post).errors.count).not_to eq(0)
      end
    end
  end

  describe "PATH update" do
    let(:valid_user) {create :user}
    let(:invalid_user) {create :user}
    let(:post) {create :post, user: valid_user}
    let(:edit_content) {"Edit content"}

    context "success update a post" do
      before do
        log_in valid_user
        patch :update, params: {post: {content: edit_content}, id: post.id}, format: :js
      end

      it "post content update" do
        expect(assigns(:post).content).to eq(edit_content)
      end

      it "show flash update post success" do
        expect(flash[:success]).to eq("Update post successfully")
      end
    end

    context "failure update a post when invalid user" do
      before do
        log_in invalid_user
        patch :update, params: {post: {content: edit_content}, id: post.id}, format: :js
      end

      it "post content not update" do
        post.reload
        expect(post.content).not_to eq(edit_content)
      end

      it "show flash update post fail" do
        expect(flash[:danger]).to eq("Post invalid")
      end
    end
  end

  describe "DELETE destroy" do
    let(:valid_user) {create :user}
    let(:invalid_user) {create :user}
    let(:post) {create :post, user: valid_user}

    context "success destroy a post" do
      before do
        log_in valid_user
        delete :destroy, params: {id: post.id},  format: :js
      end

      it "remove post from database" do
        expect { post.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "show flash destroy post success" do
        expect(flash[:success]).to eq("Delete post successfully")
      end
    end

    context "failure update a post when invalid user" do
      before do
        log_in invalid_user
        delete :destroy, params: {id: post.id},  format: :js
      end

      it "not remove post from database" do
        post.reload
        expect(post.persisted?).to be_truthy
      end

      it "show flash update post fail" do
        expect(flash[:danger]).to eq("Post invalid")
      end
    end
  end
end
