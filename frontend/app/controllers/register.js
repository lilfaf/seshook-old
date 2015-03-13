import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    register: function() {
      var self = this;
      this.get('model').save().then(function(user) {
        self.get('session').authenticate('simple-auth-authenticator:oauth2-password-grant', {
          identification: user.get('email'),
          password: user.get('password')
        });
      }, function() {});
    }
  }
});
