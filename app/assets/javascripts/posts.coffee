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

    if $("input#select-all-posts").length > 0
      $("input#select-all-posts").on "click", () ->
        if $(this).prop("checked")
          $("input.select-post").prop("checked", true)
        else
          $("input.select-post").prop("checked", false)

    if $("a#schedule-posts-link").length > 0
      $("a#schedule-posts-link").on "click", (e) =>
        e.preventDefault()
        if $("input.select-post:checked").length > 0
          showScheduleMultipleModal()

    if $("button#schedule-multiple-posts-button").length > 0
      $("button#schedule-multiple-posts-button").unbind('click').bind "click", (e) ->
        e.preventDefault()
        showScheduleMultiplePosts()

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

  showScheduleMultipleModal = ->
    $("#scheduleMultiplePosts").modal("show")

  showScheduleMultiplePosts = ->
    return if $("input.select-post:checked").length == 0 || $("#scheduled_at").val().length == 0
    ids = []
    $("input.select-post:checked").map ->
      ids.push($(this).data("id"))
    scheduled_at = $("#scheduled_at").val()

    $("#status-model .modal-body p").html('')
    $.ajax
      url: $("a#schedule-posts-link").data("url"),
      method: $("a#schedule-posts-link").data("method")
      data: { ids: ids, data: { scheduled_at: scheduled_at } }
      success: (data)->
        $("#scheduleMultiplePosts").modal("hide")
        $("#status-model").modal("show")
        $("#status-model .modal-body p").html(data.message)


  init = ->
    bindEvents()
    showHideSchedlingField($("select#post_state")) if $("select#post_state").length > 0
    enableDisableScheduledAt($("input#post_scheduled_at")) if $("input#post_scheduled_at").length > 0

  return {
    init: init
  }
)