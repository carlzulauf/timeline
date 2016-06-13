class PagesController < ApplicationController
  def index
    current_user.stream_tweets! if logged_in?
  end
end
