class Post < ApplicationRecord
  belongs_to :user

  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_fit: Settings.img.size_500_500
  end

  scope :newest, ->{order(created_at: :desc)}

  scope :relate_post, ->(user_ids){where(user_id: user_ids)}

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
