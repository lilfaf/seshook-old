import Ember from 'ember';
import Oauth2 from 'simple-auth-oauth2/authenticators/oauth2';

export default Oauth2.extend({
  provider: 'facebook-oauth2',

  authenticate: function() {
    var _this = this;
    return new Ember.RSVP.Promise(function(resolve, reject) {
      _this.torii.open(_this.provider).then(function(data) {
        var params = {
          user: { facebook_auth_code: data.authorizationCode }
        };
        _this.makeRequest('/api/users/facebook', params).then(function(response) {
          Ember.run(function() {
            var expiresAt = _this.absolutizeExpirationTime(response.expires_in);
            _this.scheduleAccessTokenRefresh(response.expires_in, expiresAt, response.refresh_token);
            if (!Ember.isEmpty(expiresAt)) {
              response = Ember.merge(response, {
                expires_at: expiresAt
              });
            }
            resolve(response);
          });
        }, function(xhr) {
          Ember.run(function() {
            reject(xhr.responseJSON || xhr.responseText);
          });
        });
      }, reject);
    });
  },
});
