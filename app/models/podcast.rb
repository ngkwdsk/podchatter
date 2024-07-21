class Podcast < ApplicationRecord
  validates :show_id, presence: true	
  has_many :likes

  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
end
