class TwitterCredentialsController < ApplicationController
  def show
    current_user.stream_tweets!
    credential = current_user.credentials.find(params[:id])
    @tweets = TimelineWaiter.new(credential).perform.latest
  end
end
