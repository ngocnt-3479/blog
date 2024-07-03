class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @post = current_user.posts.build
    @pagy, @feed_items = pagy current_user.feed
                                          .visible_to_user(current_user)
                                          .newest
  end
end
