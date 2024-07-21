class PodcastsController < ApplicationController
  before_action :set_podcast, only: [:show]
  before_action :move_to_index, except: [:index, :show, :search]
  
  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])
  
  def index
    @podcasts = Podcast.all
    @podcast_data = @podcasts.map{ |podcast| get_podcast_data(podcast) }
  end
  
  def show
  end

  def search
    @podcast = Podcast.new
    if params[:search].present?
      @searchpodcasts = RSpotify::Show.search(params[:search], limit: 10, market: 'JP')
    end
  end

  def create
    @podcast = Podcast.new(show_id: params[:show_id])
    if @podcast.save
      redirect_to podcasts_path, notice: '登録されました！'
    else
      redirect_to search_podcasts_path, alert: @podcast.errors.full_messages.to_sentence
    end
  end

  private

  PodcastData = Struct.new(:id, :image, :name, :description)

  def get_podcast_data(spotify_show)
    show = RSpotify::Show.find(spotify_show.show_id)
    return if show.nil?
    image = show.images.empty? ? nil : show.images.first["url"]
    PodcastData.new(spotify_show.id, image, show.name, show.description)
  end

  def set_podcast
    @podcast = get_podcast_data(Podcast.find(params[:id]))
  end
  
  def move_to_index
    unless user_signed_in?
      redirect_to root_path
    end
  end

  def podcast_params
    params.require(:podcast).permit(:show_id)
  end
  
end

	
