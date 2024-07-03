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
        post :create, xhr: true, params: {post: vaild_post_params, user_id: user.id}
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
        post :create, xhr: true, params: {post: invalid_spost_params, user_id: user.id}
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
        patch :update, xhr: true, params: {post: {content: edit_content}, id: post.id}
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
        patch :update, xhr: true, params: {post: {content: edit_content}, id: post.id}
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
        delete :destroy, xhr: true, params: {id: post.id}
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
        delete :destroy, xhr: true, params: {id: post.id}
      end

      it "not remove post from database" do
        post.reload
        expect(post.persisted?).to be_truthy
      end

      it "show flash update post fail" do
        expect(flash[:danger]).to eq("Post invalid")
      end
    end

    describe "PATH update_status" do
      let(:valid_user) {create :user}
      let(:invalid_user) {create :user}
      let(:post) {create :post, user: valid_user}

      context "success update status a post" do
        before do
          log_in valid_user
          patch :update_status, xhr: true, params: {status: :private, id: post.id}
        end

        it "post status update" do
          expect(assigns(:post).isPrivate).to be_truthy
        end

        it "show flash update post success" do
          expect(flash[:success]).to eq("Change status post to private success")
        end
      end

      context "failure update status a post when invalid user" do
        before do
          log_in invalid_user
          patch :update_status, xhr: true, params: {status: :private, id: post.id}
        end

        it "post content not update" do
          post.reload
          expect(post.isPrivate).not_to be_truthy
        end

        it "show flash update post fail" do
          expect(flash[:danger]).to eq("Post invalid")
        end
      end
    end
  end
end
