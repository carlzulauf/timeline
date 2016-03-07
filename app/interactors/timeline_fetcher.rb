class TimelineFetcher
  attr_reader :credential, :client

  def initialize(credential)
    @credential = credential
    @client     = credential.rest_client
  end

  def perform
    binding.pry
  end
end
