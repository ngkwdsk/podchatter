class PodcastsController < ApplicationController
  before_action :set_post, only: [:edit, :show]
  before_action :move_to_index, except: [:index, :show]
  
  require 'rspotify'
  RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])
  
  def search
    @podcast = Podcast.new
    if params[:search].present?
      @searchpodcasts = RSpotify::Show.search(params[:search])
      Rails.logger.debug @searchpodcasts.inspect
    end
  end
  
  def index
    @podcasts = Podcast.all
  end
    
  def show
  end
  
  private

  def set_post
    @podcast =Podcast.find(params[:id])
  end
  
  def move_to_index
    unless user_signed_in?
      redirect_to root_path
    end
  end
end

	
