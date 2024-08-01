module ApplicationHelper
  def user_icon_url(user)
    if user.icon.attached?
      rails_blob_url(user.icon, only_path: true)
    else
      asset_path('default.jpg')
    end
  end
end