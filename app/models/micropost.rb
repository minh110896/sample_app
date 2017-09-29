class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.content.maximum}
  default_scope ->{order(created_at: :desc)}
  # scope :feed_by_user, ->(id){where("user_id = ?", id)}
  scope :feed_by_user, ->(user){where "user_id IN (?) OR user_id = ?", user.following_ids, user.id}

  private

  def picture_size
    return if picture.size > Settings.picture.size.megabytes
    errors.add(:picture, (t "models.micropost.warn"))
  end
end
