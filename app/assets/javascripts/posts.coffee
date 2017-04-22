# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

TweetDeck.createModule("TweetDeck.posts", ->
  bindEvents = ->
    if $("select#post_state").length > 0
      $("select#post_state").on "change", (e) ->
        e.preventDefault()
        showHideSchedlingField($(this))

    if $("input#post_tweet_now").length > 0
      $("input#post_tweet_now").on "click", (e) ->
        enableDisableScheduledAt($(this))


  enableDisableScheduledAt = (el) ->
    if el.prop("checked")
      $("input#post_scheduled_at").val('')
      $("input#post_scheduled_at").prop('disabled', true)
    else
      $("input#post_scheduled_at").prop('disabled', false)


  showHideSchedlingField = (el) ->
    if el.val() == "ready"
      $(".schedule-input").show()
    else
      $(".schedule-input").hide()
      $(".schedule-input input:checkbox").prop("checked", false)
      $(".schedule-input input:not(:checkbox)").val('')
      $("input#post_scheduled_at").prop('disabled', false)




  init = ->
    bindEvents()
    showHideSchedlingField($("select#post_state")) if $("select#post_state").length > 0
    enableDisableScheduledAt($("input#post_scheduled_at")) if $("input#post_scheduled_at").length > 0

  return {
    init: init
  }
)