import Ember from "ember";

var LoginRoute = Ember.Route.extend({
  setupController: function(controller) {
    //clear a potentially stale error message from previous login attempts
    controller.set('errorMessage', null);
  }
  //,
  //actions: {
  //  // display an error when authentication fails
  //  sessionAuthenticationFailed: function(error) {
  //    console.log(error);
  //    //message = error.error_description;
  //    this.controller.set('errorMessage', 'Invalid email or password');
  //  },
  //  closeErrorMessage: function() {
  //    this.controller.set('errorMessage', null);
  //  }
  //}
});

export default LoginRoute;