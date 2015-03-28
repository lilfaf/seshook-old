import Ember from 'ember';
import AuthenticatedRouteMixin from 'simple-auth/mixins/authenticated-route-mixin';

var ProfileRoute = Ember.Route.extend(AuthenticatedRouteMixin, {
  model: function() {
    return this.store.find('user', this.get('session.user_id'));
  },

  actions: {
    closeMessage: function() {
      this.controller.set('message', null);
    }
  }
});

export default ProfileRoute;