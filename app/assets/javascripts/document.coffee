# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

TweetDeck.createModule("TweetDeck.documents", ->
  bindEvents = ->
    if $("input#document-file-posts").length >  0
      $("#document-file-posts").on "change", ->
        $("#document-file-post-form").submit()

  init = ->
    bindEvents()

  return {
    init: init
  }
)
