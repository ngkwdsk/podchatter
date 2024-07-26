class CommentChannel < ApplicationCable::Channel
  def subscribed
    @podcast = Podcast.find(params[:podcast_id])
    stream_for @podcast
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
