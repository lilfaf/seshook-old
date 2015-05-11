import Ember from 'ember';
import AuthenticatedRouteMixin from 'simple-auth/mixins/authenticated-route-mixin';
import InfinityRoute from 'ember-infinity/mixins/route';

export default Ember.Route.extend(AuthenticatedRouteMixin, InfinityRoute, {
  queryParams: {
    q: {
      refreshModel: true
    }
  },
  model: function(params) {
    return this.infinityModel('spot', {
      perPage: 25,
      startingPage: 1,
      q: params.q
    });
  }
});
