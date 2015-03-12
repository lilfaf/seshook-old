import Ember from 'ember';
import LoginControllerMixin from 'simple-auth/mixins/login-controller-mixin';

export default Ember.Controller.extend(LoginControllerMixin, {
  authenticator: 'simple-auth-authenticator:oauth2-password-grant',

  actions: {
    authenticate: function() {
      // Fix https://github.com/simplabs/ember-simple-auth/issues/439
      // Catch the failed promise in the SimpleAuth.LoginControllerMixin authenticate action
      this._super().catch(Ember.K);
    }
  }
});
