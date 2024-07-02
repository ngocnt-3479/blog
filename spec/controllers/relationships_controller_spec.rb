require "rails_helper"
require "shared_examples"
include SessionsHelper

RSpec.describe RelationshipsController, type: :controller do
  let(:user) {create :user}
  let(:other_user) {create :user}

  describe "POST create" do
    context "success create" do
      before do
        log_in user
        post :create, xhr: true, params: {followed_id: other_user.id}
      end

      it "should have a new follow" do
        expect(Relationship.where(follower_id: user.id, followed_id: other_user.id)).to exist
      end

      it "show flash follow user successfully" do
        expect(flash[:success]).to eq("Follow user successfully")
      end
    end

    context "fail when followed user not found" do
      before do
        log_in user
        post :create, xhr: true, params: {followed_id: -1}
      end

      it "show flash user not found" do
        expect(flash[:danger]).to eq("User not found")
      end

      it_behaves_like "redirect to home page"
    end
  end

  describe "DELETE destroy" do
    context "success destroy" do
      before do
        log_in user
        user.follow other_user
        relationship = user.active_relationships.find_by(follower_id: user.id, followed_id: other_user.id)
        delete :destroy, xhr: true, params: {id: relationship.id}
      end

      it "remove relationship from database" do
        expect(Relationship.where(follower_id: user.id, followed_id: other_user.id)).to_not exist
      end
    end

    context "fail when relationship not found" do
      before do
        log_in user
        user.follow other_user
        delete :destroy, xhr: true, params: {id: 0}
      end

      it "show flash relationship not found" do
        expect(flash[:danger]).to eq("Relationship not found")
      end

      it_behaves_like "redirect to home page"
    end
  end
end
