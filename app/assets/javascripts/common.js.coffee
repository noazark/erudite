History = window.History
$ ->
  requests = []
  url = ""
  $("#search").keyup ->
    $.each(requests, ((i, request)->
      request.abort()
    ))

    $.rails.handleRemote $("#search_form")

  $("#search_form").bind "ajax:beforeSend", (event, xhr, settings) ->
    requests.push xhr
    url = settings.url

  $("#search_form").bind "ajax:success", (event, data, status, xhr) ->
    $("#search_results").html $.tmpl("tmpl/search", data)
    History.pushState null, null, url
