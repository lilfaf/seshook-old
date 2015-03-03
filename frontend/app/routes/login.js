import Ember from "ember";

var LoginRoute = Ember.Route.extend({
  setupController: function(controller) {
    //clear a potentially stale error message from previous login attempts
    controller.set('errorMessage', null);
  }
});

export default LoginRoute;