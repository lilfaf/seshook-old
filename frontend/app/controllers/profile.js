import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    save: function() {
      var self = this;
      this.get('model').save().then(function(user) {
        self.set('session.currentUser', user);
        self.set('message', 'Your profile was updated successfully.');
      }, function() {
        self.set('message', null);
      });
    },

    openFileDialog: function() {
      Ember.$('input[type=file]').click();
    }
  }
});
