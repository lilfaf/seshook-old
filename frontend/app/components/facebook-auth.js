import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    authenticateWithFacebook: function() {
      this.get('session').authenticate('authenticator:facebook');
    }
  }
});
