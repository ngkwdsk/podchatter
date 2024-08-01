class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @podcast = Podcast.find(params[:podcast_id])
    if @comment.save
      icon_url = rails_blob_url(@comment.user.icon) if @comment.user.icon.attached?
      CommentChannel.broadcast_to @podcast, { comment: @comment, user: @comment.user, created_at: @comment.created_at.strftime("%Y-%m-%d %H:%M"), icon_url: icon_url }
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id, podcast_id: params[:podcast_id])
  end
end
