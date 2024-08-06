class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :profile, length: { maximum: 140 }

  has_many :likes
  has_many :comments
  has_one_attached :icon

  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id
  has_many :followings, through: :active_relationships, source: :follower

  has_many :passive_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :followers, through: :passive_relationships, source: :following

  def followed_by?(user)
    passive_relationships.find_by(following_id: user.id)
  end
  
  after_create :set_default_icon

  private
  
  def set_default_icon
    unless icon.attached?
      default_image_path = Rails.root.join("app/assets/images/default.jpg")
      icon.attach(io: File.open(default_image_path), filename: 'default.jpg', content_type: 'image/jpeg')
    end
  end
end
