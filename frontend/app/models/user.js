import Ember from 'ember';
import DS from 'ember-data';

var User = DS.Model.extend({
  email:                DS.attr('string'),
  password:             DS.attr('string'),
  passwordConfirmation: DS.attr('string'),
  createdAt:            DS.attr('date'),
  updatedAt:            DS.attr('date'),

  isntValid: Ember.computed.not('isValid')
});

export default User;
