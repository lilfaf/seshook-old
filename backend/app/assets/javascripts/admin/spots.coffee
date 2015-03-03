#= require mapbox
#= require exif

jQuery ->
  container = $('#map')
  if container.length
    map = new Map(container.data('latlon'))

  # reverse geocoding from image exif on spots creation
  input = $('#spot_photos').change ->
    return unless file = @files[0]
    ReverseGeocoder.getInfo file, (data) ->
      $('#spot_address_attributes_street').val(data.street)
      $('#spot_address_attributes_city').val(data.city)
      $('#spot_address_attributes_zip').val(data.zip)
      $('#spot_address_attributes_state').val(data.state)
      $('#spot_address_attributes_country_code').val(data.country)
      $('#spot_latitude').val(data.latlon[0])
      $('#spot_longitude').val(data.latlon[1])
      # set map position
      map.setMarker(data.latlon)

  # init jasny file input preview
  $('.fileinput').fileinput()

class @Map
  token: 'pk.eyJ1IjoibGlsZmFmIiwiYSI6InY2TUktVkUifQ.eVZ3ivj1dlTxTAsJYRQI3g'
  mapId: 'lilfaf.l26132mi'
  zoom: 16
  editable: true

  constructor: (coords) ->
    L.mapbox.accessToken = @token
    # initialize map
    coords = if coords && validateCoords(coords) then coords else [45.753363, 4.868605]
    @map = L.mapbox.map('map', @mapId)
    @setMarker(coords)

    # bind input events to map
    @latIn = $('#spot_latitude')
    @lonIn = $('#spot_longitude')
    @bindInputsEvents()

  validateCoords = (coords) ->
    for val in coords
      return false if isNaN(parseFloat(val))
    true

  setMarker: (coords) ->
    if validateCoords(coords)
      @map.removeLayer(@marker) if @marker
      @map.setView(coords, @zoom)
      @marker = L.marker(coords, draggable: @editable).addTo(@map)
      @bindMarkerEvents()

  bindMarkerEvents: ->
    self = @
    @marker.on 'dragend', (e) ->
      pos = e.target.getLatLng()
      self.latIn.val(pos.lat)
      self.lonIn.val(pos.lng)

  bindInputsEvents: ->
    self = @
    @latIn.on 'input', (e) ->
      self.setMarker [e.target.value, self.lonIn.val()]
    @lonIn.on 'input', (e) ->
      self.setMarker [self.latIn.val(), e.target.value]

E = EXIF
class @ReverseGeocoder
  osmUrl: 'http://nominatim.openstreetmap.org/reverse?format=json&addressdetails=1'

  constructor: (file, callback) ->
    @file = file
    @callback = callback

  @getInfo: (file, callback) ->
    rg = new @ file, callback
    res = rg.getLatLon()

  getLatLon: ->
    self = @
    E.getData @file, ->
      lat = E.getTag(@, 'GPSLatitude')
      lon = E.getTag(@, 'GPSLongitude')
      if lat && lon
        latRef = E.getTag(@, 'GPSLatitudeRef') ? 'N'
        lonRef = E.getTag(@, 'GPSLongitudeRef') ? 'W'
        latlon = self.convertCoordinates(lat, lon, latRef, lonRef)
        self.reverseGeocode latlon, (data) ->
          self.callback(data)

  convertCoordinates: (lat, lon, latRef, lonRef) ->
    lat = (lat[0] + lat[1]/60 + lat[2]/3600) * (if latRef == 'N' then 1 else -1)
    lon = (lon[0] + lon[1]/60 + lon[2]/3600) * (if lonRef == 'W' then -1 else 1)
    [lat, lon]

  reverseGeocode: (latlon, callback) ->
    $.getJSON "#{@osmUrl}&lat=#{latlon[0]}&lon=#{latlon[1]}", (data) ->
      info = data.address
      data =
        street:  (info.road || info.pedestrian || info.path || info.footway || info.cycleway || info.highway),
        city:    (info.city || info.town || info.village),
        state:   info.state
        zip:     (info.postcode || '').split(/;(.+)?/)[0],
        country: info.country_code.toUpperCase(),
        latlon:  latlon
      callback(data)
