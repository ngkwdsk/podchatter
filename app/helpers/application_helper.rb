module ApplicationHelper
  def user_icon(user)
    if user.icon.attached?
      user.icon
    else
      'path/to/default/icon.jpg'
    end
  end
end