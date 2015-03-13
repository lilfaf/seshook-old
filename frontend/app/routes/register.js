import Ember from 'ember';

var RegisterRoute = Ember.Route.extend({
  model: function() {
    return this.store.createRecord('user');
  }
});

export default RegisterRoute;
