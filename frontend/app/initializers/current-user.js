import Ember from 'ember';
import Session from 'simple-auth/session';

export default {
  name: 'current-user',
  before: 'simple-auth',
  initialize: function(container) {
    Session.reopen({
      setCurrentUser: function() {
        var id = this.get('user_id');
        var self = this;
        if (!Ember.isEmpty(id)) {
          return container.lookup('store:main').find('user', id).then(function(user) {
            console.log('hello');
            self.set('currentUser', user);
          });
        }
      }.observes('user_id')
    });
  }
};
