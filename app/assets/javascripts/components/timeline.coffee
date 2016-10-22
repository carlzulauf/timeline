class @Timeline
  constructor: ($el) ->
    @$ = $el
    @tweets = Tweet.from_array(window.tweets)
    @template = $("#tweet-template").text()

    @tweet_width = 350
    @current_column = 0

    Mustache.parse(@template)

    @listen()
    @renderAll()
    @addRandomTweets()

  listen: ->
    $(window).on "resize", =>
      @renderAll()

  addRandomTweets: ->
    # window.setTimeout( (=> @addTweet(@randomTweet()) ), 2000 )
    window.setInterval( (=> @addTweet(@randomTweet()) ), 2000 )

  randomTweet: ->
    @tweets[Math.floor(Math.random() * @tweets.length)]

  addTweet: (tweet) ->
    @tweets.unshift tweet
    @tweets.pop
    $tweet = $(Mustache.render(@template, tweet.data()))
    $row = @currentRow()
    # $holder = $($row.find(".tweet")[@columns - @current_column - 1])

    $stale_row = null
    if @$.find(".tweet-row").length * 150 > @height * 2
      $stale_row = @$.find(".tweet-row:last-child")

    requestAnimationFrame =>
      $row.prepend($tweet)
      # window.last_holder = $holder
      # $holder.replaceWith($tweet)
      @current_column++

      if @current_column == 1
        $row.addClass("in")
        if @$last_row
          @$last_row.addClass("out")
          @$last_row.removeClass("in")
        if $stale_row
          console.log "removing stale row"
          $stale_row.remove()

      if @current_column == @columns
        $row.removeClass("current-tweet-row")
        @$.prepend @newRow()
        @$last_row = $row
        @$current_row = null
        @current_column = 0

  currentRow: ->
    unless @$current_row
      @$current_row = @$.find(".current-tweet-row")
      # for col in [0...@columns]
      #   @$current_row.append('<div class="tweet out"></div>')
    @$current_row

  measure: ->
    @width = @$.width()
    @height = $(window).height()
    @columns = Math.max(1, Math.floor(@width / @tweet_width))
    console.log [@width, @columns]

  newRow: ->
    "<div class=\"current-tweet-row tweet-row\"></div>"

  renderAll: ->
    @measure()
    col = 0
    body = "#{@newRow()}<div class=\"tweet-row\">"
    for tweet in @tweets
      body += Mustache.render(@template, tweet.data())
      col++
      if col == @columns
        body += "</div><div class=\"tweet-row\">"
        col = 0
    body += "</div>"
    requestAnimationFrame =>
      @$.html(body)
      @$current_row = null
      @current_column = 0

$ ->
  $tweets = $(".tweets")
  if $tweets.length > 0
    window.timeline = new Timeline($tweets)
