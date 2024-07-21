class LikesController < ApplicationController
  def create
    like = current_user.likes.build(podcast_id: params[:podcast_id])
    like.save
    redirect_to root_path
  end

  def destroy
    like = Like.find_by(podcast_id: params[:podcast_id], user_id: current_user.id)
    like.destroy
    redirect_to root_path
  end
end
