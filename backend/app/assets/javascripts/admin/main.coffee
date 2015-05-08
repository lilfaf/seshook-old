#= require modernizr
#= require swipebox

jQuery ->
  # init swipebox
  el = $('.swipebox')
  el.swipebox() if el.length

  # init tooltips on no touch devices
  if !Modernizr.touch
    $('[data-toggle="tooltip"]').tooltip()
