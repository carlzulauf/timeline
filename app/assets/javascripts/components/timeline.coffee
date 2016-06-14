class @Timeline
  constructor: ($el) ->
    @$ = $el
    @tweets = Tweet.from_array(window.tweets)
    @template = $("#tweet-template").text()

    @tweet_width = 350

    Mustache.parse(@template)

    @listen()
    @renderAll()
    @addRandomTweets()

  listen: ->
    $(window).on "resize", =>
      @renderAll()

  addRandomTweets: ->
    # window.setTimeout

  randomTweet: ->
    @tweets[Math.floor(Math.random() * @tweets.length)]

  measure: ->
    @width = @$.width()
    @columns = Math.max(1, Math.floor(@width / @tweet_width))
    console.log [@width, @columns]

  renderAll: ->
    @measure()
    col = 0
    body = "<div class=\"tweet-row\">"
    for tweet in @tweets
      body += Mustache.render(@template, tweet.data())
      col++
      if col == @columns
        body += "</div><div class=\"tweet-row\">"
        col = 0
    body += "</div>"
    window.requestAnimationFrame =>
      @$.html(body)

$ ->
  $tweets = $(".tweets")
  if $tweets.length > 0
    window.timeline = new Timeline($tweets)
