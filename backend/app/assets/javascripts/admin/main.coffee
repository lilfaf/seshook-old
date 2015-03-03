#= require ../application
#= require jasny-bootstrap
#= require s3_relay
#= require swipebox
#= require_tree .

jQuery ->
  el = $('.swipebox')
  el.swipebox() if el.length
