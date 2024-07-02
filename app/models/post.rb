class Post < ApplicationRecord
  belongs_to :user
  has_many :reactions, dependent: :destroy
  has_many :liked_users, through: :reactions, source: :user

  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_fit: Settings.img.size_500_500
  end

  scope :newest, ->{order(created_at: :desc)}

  scope :relate_post, ->(user_ids){where(user_id: user_ids)}

  scope :visible_to_user, lambda {|current_user|
    where("isPrivate = ? OR user_id = ?", false, current_user.id)
  }

  validates :content,
            presence: true,
            length: {maximum: Settings.digit.length_140}

  validates :image,
            content_type: {
              in: Settings.img.valid_type,
              message: "Invalid image format"
            },
            size: {
              less_than: Settings.digit.size_5.megabytes,
              message: "Invalid image size"
            }
end
