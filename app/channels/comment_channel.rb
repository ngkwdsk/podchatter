class CommentChannel < ApplicationCable::Channel
  def subscribed
    @podcast = Podcast.find(params[:podcast_id])
    stream_for @podcast
  end

  def receive(data)
    user = User.find(data['user_id'])
    comment = user.comments.create!(text: data['text'], podcast_id: data['podcast_id'])
    
    CommentChannel.broadcast_to(
      comment.podcast,
      comment: comment.as_json,
      user: user.as_json.merge(icon_url: user.icon_url),
      created_at: comment.created_at.strftime('%Y-%m-%d %H:%M:%S')
    )
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
