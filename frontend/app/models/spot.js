import DS from 'ember-data';

export default DS.Model.extend({
  name:    DS.attr('string'),
  latlon:  DS.attr('array'),
  address: DS.belongsTo('address'),

  location: function() {
    return L.latLng(this.get('latlon')[0], this.get('latlon')[1]);
  }.property('latlon')
});