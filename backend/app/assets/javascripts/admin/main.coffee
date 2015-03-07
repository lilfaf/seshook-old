#= require ../application
#= require jasny-bootstrap
#= require s3_relay
#= require swipebox
#= require_tree .

jQuery ->
  # init swipebox
  el = $('.swipebox')
  el.swipebox() if el.length

  # init tooltips on no touch devices
  if !Modernizr.touch
    $('[data-toggle="tooltip"]').tooltip()
