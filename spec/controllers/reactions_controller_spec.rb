require "rails_helper"
require "shared_examples"
include SessionsHelper

RSpec.describe ReactionsController, type: :controller do
  describe "POST create" do
    let(:valid_user) {create :user}
    let(:invalid_user) {create :user}
    let(:post1) {create :post, user: valid_user}

    context "success create" do
      before do
        log_in valid_user
        post :create, xhr: true, params: {post_id: post1.id, user_id: valid_user.id}
      end

      it "should have a new reaction" do
        expect(Reaction.where(user_id: valid_user.id, post_id: post1.id)).to exist
      end
    end

    context "fail when post not found" do
      before do
        log_in valid_user
        post :create, xhr: true, params: {post_id: -1}
      end

      it "show flash post not found" do
        expect(flash[:danger]).to eq("Post not found")
      end

      it_behaves_like "redirect to home page"
    end
  end

  describe "DELETE destroy" do
    let(:valid_user) {create :user}
    let(:invalid_user) {create :user}
    let(:post1) {create :post, user: valid_user}

    context "success destroy" do
      before do
        log_in valid_user
        valid_user.reaction post1
        reaction = valid_user.reactions.find_by(user_id: valid_user.id, post_id: post1.id)
        delete :destroy, xhr: true, params: {id: reaction.id}
      end

      it "remove reaction from database" do
        expect(Reaction.where(user_id: valid_user.id, post_id: post1.id)).to_not exist
      end
    end

    context "fail when reaction not found" do
      before do
        log_in valid_user
        valid_user.reaction post1
        delete :destroy, xhr: true, params: {id: 0}
      end

      it "show flash reaction not found" do
        expect(flash[:danger]).to eq("Reaction not found")
      end

      it_behaves_like "redirect to home page"
    end
  end
end
