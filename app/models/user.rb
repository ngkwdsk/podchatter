class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :profile, length: { maximum: 140 }

  has_many :likes
  has_many :comments
  has_one_attached :icon
  
  after_create :set_default_icon

  private
  
  def set_default_icon
    unless icon.attached?
      default_image_path = Rails.root.join("app/assets/images/default.jpg")
      icon.attach(io: File.open(default_image_path), filename: 'default.jpg', content_type: 'image/jpeg')
    end
  end

end
