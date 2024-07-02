# frozen_string_literal: true

class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name,
            foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
            foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :reactions, dependent: :destroy
  has_many :liked_posts, through: :reactions, source: :post

  before_save :downcase_email

  scope :all_except, ->(user){where.not(id: user)}

  validates :name,
            presence: true,
            length: {maximum: Settings.digit.length_50}

  validates :email,
            presence: true,
            length: {maximum: Settings.digit.length_255},
            format: {with: Settings.regex.email},
            uniqueness: {case_sensitive: false}

  validates :password,
            presence: true,
            length: {minimum: Settings.digit.length_8},
            allow_nil: true

  has_secure_password

  def feed
    Post.relate_post(following_ids << id).includes(:user,
                                                   image_attachment: :blob)
  end

  def follow other_user
    following << other_user
  end

  def unfollow other_user
    following.delete other_user
  end

  def following? other_user
    following.include? other_user
  end

  def reaction post
    liked_posts << post
  end

  def unreaction post
    liked_posts.delete post
  end

  def liked? post
    liked_posts.include? post
  end

  private

  def downcase_email
    email.downcase!
  end
end
