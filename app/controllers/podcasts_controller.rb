class PodcastsController < ApplicationController
  before_action :set_podcast, only: [:show, :show_episodes]
  before_action :move_to_index, except: [:index, :show, :search]

  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])

  def index
    @podcasts = Podcast.all
    @podcast_data = @podcasts.map{ |podcast| get_podcast_data(podcast) }
    show_episodes if @podcast.present?
    if user_signed_in?
      @liked_podcast = @podcasts.select{ |podcast| podcast.likes.exists?(user_id: current_user.id) }.map{ |podcast| get_podcast_data(podcast) }
      @not_liked_podcast = @podcasts.select{ |podcast| !podcast.likes.exists?(user_id: current_user.id) }.map{ |podcast| get_podcast_data(podcast) }
    else
      @liked_podcast = []
      @not_liked_podcast = @podcast_data
    end
  end

  def show
    if @podcast.nil?
      redirect_to root_path, alert: 'Podcast not found'
      return
    end
    @comments = @podcast.original_podcast.comments.includes(:user)
    @comment = Comment.new
    show_episodes
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
      @like = current_user.likes.create!(podcast_id: @podcast.id)
      redirect_to root_path
    else
      redirect_to search_podcasts_path, alert: @podcast.errors.full_messages.to_sentence
    end
  end

  def show_episodes
    if @podcast.present? && @podcast.original_podcast.present?
      @episodes = get_episodes(@podcast.original_podcast.show_id)
    else
      @episodes = []
    end
  end

  def index_user
    @user = User.find_by(id: params[:id])
    @liked_podcasts = @user.likes.map { |like| like.podcast }
    @liked_podcast_data = @liked_podcasts.map { |podcast| get_podcast_data(podcast) }
  end

  private

  PodcastData = Struct.new(:id, :image, :name, :description, :original_podcast, :latest_episode)
  
  def get_podcast_data(spotify_show)
    show = RSpotify::Show.find(spotify_show.show_id)
    return if show.nil?
    image = show.images.first.nil? ? nil : show.images.first["url"]
    PodcastData.new(spotify_show.id, image, show.name, show.description, spotify_show)
  end

  def get_podcast_data(spotify_show)
    show = RSpotify::Show.find(spotify_show.show_id)
    return if show.nil?
    image = show.images.first.nil? ? nil : show.images.first["url"]
    latest_episode = get_latest_episode(show)
    PodcastData.new(spotify_show.id, image, show.name, show.description, spotify_show, latest_episode)
  end

  def get_episodes(show_id)
    show = RSpotify::Show.find(show_id)
    return [] if show.nil?
    show.episodes(limit: 5).map do |episode|
      { id: episode.id, title: episode.name }
    end
  end

  
  def get_latest_episode(show)
    episodes = show.episodes(limit: 1)
    return nil if episodes.empty?
    episode = episodes.first
    { id: episode.id, title: episode.name }
  end

  def set_podcast
    podcast_instance = Podcast.find(params[:id])
    @podcast = get_podcast_data(podcast_instance) unless podcast_instance.nil?
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