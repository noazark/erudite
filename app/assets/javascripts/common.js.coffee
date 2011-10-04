$ ->
  requests = []
  $("#search").keyup ->
    i = 0
    while i < requests.length
      requests[i].abort()
      i++

    requests.push $.getJSON $("#search_form").attr("action"), $("#search_form").serialize(), ((data)->
      $("#search_results").html($.tmpl('tmpl/search', data))
    ), "script"
