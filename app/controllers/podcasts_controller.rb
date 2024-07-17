class PodcastsController < ApplicationController
  before_action :set_post, only: [:edit]
  before_action :move_to_index, except: [:index, :show]
  
  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])
  
  def search
    @podcast = Podcast.new
    if params[:search].present?
      @searchpodcasts = RSpotify::Artist.search(params[:search])
      Rails.logger.debug @searchpodcasts.inspect
    end
  end

  def show 
  end

  def index
    @podcasts = Podcast.all
    @podcast_data = @podcasts.map{ |podcast| get_podcast_data(podcast) }
  end
  
  private

  PodcastData = Struct.new(:image, :name, :description)

  def get_podcast_data(spotify)
    show = RSpotify::Show.find(spotify.show_id)
    return if show.nil?
    image = show.images.empty? ? nil : show.images.first["url"]
    PodcastData.new(image, show.name, show.description)
  end

  def set_post
    @podcast =Podcast.find(params[:id])
  end
  
  def move_to_index
    unless user_signed_in?
      redirect_to root_path
    end
  end
end

	
