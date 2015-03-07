import Ember from "ember";

var LoginRoute = Ember.Route.extend({
  setupController: function(controller) {
    //clear a potentially stale error message from previous login attempts
    controller.set('errorMessage', null);
  },
  actions: {
    // display an error when authentication fails
    sessionAuthenticationFailed: function(error) {
      var message = error.error_description;
      this.controller.set('errorMessage', message);
    },
    closeErrorMessage: function() {
      this.controller.set('errorMessage', null);
    }
  }
});

export default LoginRoute;