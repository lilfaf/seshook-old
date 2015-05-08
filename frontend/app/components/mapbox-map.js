import EmberLeafletComponent from 'ember-leaflet/components/leaflet-map';
import TileLayer from 'ember-leaflet/layers/tile';

export default EmberLeafletComponent.extend({
  childLayers: [
    TileLayer.extend({
      tileUrl: 'https://{s}.tiles.mapbox.com/v4/{mapId}/{z}/{x}/{y}.png?access_token={accessToken}',
      options: {
        accessToken: 'pk.eyJ1IjoibGlsZmFmIiwiYSI6InY2TUktVkUifQ.eVZ3ivj1dlTxTAsJYRQI3g',
        mapId: 'lilfaf.l26132mi'
      },
      subdomains: 'abcd',
    })
  ],
  zoom: 14
});
