import DS from 'ember-data';

export default DS.Model.extend({
  city:    DS.attr('string'),
  country: DS.attr('string'),
  state:   DS.attr('string'),
  street:  DS.attr('string'),
  zip:     DS.attr('string'),
  spot:    DS.belongsTo('spot')
});