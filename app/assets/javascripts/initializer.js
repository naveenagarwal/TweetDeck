var __hasProp = {}.hasOwnProperty;

window.TweetDeck = window.TweetDeck || {};

TweetDeck.createNamespace = function(namespace) {
    var name, namespaceArr, parent, _i, _len;
    namespaceArr = namespace.split(".");
    parent = TweetDeck;
    if (namespaceArr[0] === "TweetDeck") {
        namespaceArr = namespaceArr.slice(1);
    }
    for (_i = 0, _len = namespaceArr.length; _i < _len; _i++) {
        name = namespaceArr[_i];
        if (typeof parent[name] === "undefined") {
            parent[name] = {};
        }
        parent = parent[name];
    }
    return parent;
};

TweetDeck.createModule = function(namespace, module) {
    var attr, obj;
    obj = TweetDeck.createNamespace(namespace);
    if (typeof module === "function") {
        module = module();
    }
    for (attr in module) {
        if (!__hasProp.call(module, attr)) continue;
        if (attr in obj) {
            if (console && console.error) {
                console.error("Method/Object with the same name and namspace is already taken.");
            }
            continue;
        }
        obj[attr] = module[attr];
    }
    return null;
};

var ready = function() {
  TweetDeck.posts.init();
  TweetDeck.documents.init();

  // show spinner on AJAX start
  $(document).ajaxStart(function(){
    $("#spinner").removeClass("hide");
    $(".container").addClass("hide");

  });
  // hide spinner on AJAX stop
  $(document).ajaxStop(function(){
    $("#spinner").addClass("hide");
    $(".container").removeClass("hide");
  });

  $(document).on("turbolinks:request-start", function(){
    $("#spinner").removeClass("hide");
    $(".container").addClass("hide");
  });

  $(document).on("turbolinks:request-end", function(){
    $("#spinner").addClass("hide");
    $(".container").removeClass("hide");
  });
};

$(document).ready(ready);
$( document ).on('turbolinks:load', ready)
