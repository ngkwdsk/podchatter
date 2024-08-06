class RelationshipsController < ApplicationController
  before_action :set_user

  def create
    follow = current_user.active_relationships.new(follower_id: @user.id)
    follow.save
    respond_to do |format|
      format.html { redirect_to @user }
      format.turbo_stream
    end
  end

  def destroy
    follow = current_user.active_relationships.find_by(follower_id: @user.id)
    follow&.destroy
    respond_to do |format|
      format.html { redirect_to @user }
      format.turbo_stream
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end