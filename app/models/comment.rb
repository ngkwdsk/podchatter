class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :podcast
  validates :user, presence: true
  validates :podcast, presence: true
  validates :text, presence: true
end
