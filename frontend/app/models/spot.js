import Ember from 'ember';
import DS from 'ember-data';

var Spot = DS.Model.extend({
  name:      DS.attr('string'),
  isntValid: Ember.computed.not('isValid')
});

export default Spot;
