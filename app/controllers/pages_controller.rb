class PagesController < ApplicationController
  def index
    if logged_in?
      current_user.stream_tweets!
    end
  end
end
