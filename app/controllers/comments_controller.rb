class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @podcast = Podcast.find(params[:podcast_id])
    if @comment.save
      CommentChannel.broadcast_to @podcast, { comment: @comment, user: @comment.user }
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id, podcast_id: params[:podcast_id])
  end
end
