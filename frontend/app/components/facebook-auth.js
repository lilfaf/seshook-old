import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    authenticateWithFacebook: function() {
      var self = this;
      this.get('session').authenticate(
        'simple-auth-authenticator:torii',
        'facebook-oauth2'
      ).then(
        function() {
          return new Ember.RSVP.Promise(function(resolve, reject){
            Ember.$.ajax({
              method: 'post',
              url: 'api/users/facebook',
              dataType: 'json',
              success: Ember.run.bind(null, resolve),
              error: Ember.run.bind(null, reject),
              data: {
                user: {
                  facebook_auth_code: self.get('session.authorizationCode')
                }
              }
            }).done(function(response){
              console.log(response);
              //_this.get('session').set('user_token', response.user_token);
              //_this.get('session').set('user_email', response.user_email);
              //// With the following line, the next request to rails api is correctly authenticated,
              //// but ember-cli crashes
              //_this.transitionTo('index');
            });
          });
        },
        function(error) {
          //console.log('there was an error');
          console.log(error);
        }
      );
    }
  }
});
