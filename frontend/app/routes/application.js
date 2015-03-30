import Ember from 'ember';
import ApplicationRouteMixin from 'simple-auth/mixins/application-route-mixin';

export default Ember.Route.extend(ApplicationRouteMixin, {
  actions: {
    sessionAuthenticationSucceeded: function() {
      return this.transitionTo('index');
    },
    sessionInvalidationSucceeded: function() {
      return this.transitionTo('index');
    }
  }
});
