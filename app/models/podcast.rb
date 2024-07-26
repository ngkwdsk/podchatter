class Podcast < ApplicationRecord
  validates :show_id, presence: true	
  has_many :likes
  has_many :comments

  def liked_by?(user)
    user && likes.where(user_id: user.id).exists?
  end
end
