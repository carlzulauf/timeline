class @Tweet
  constructor: (attributes) ->
    @a = attributes

  data: ->
    author: @a.info.user.screen_name
    content: @a.info.text

  @from_array: (a) ->
    (new Tweet(x) for x in a)
