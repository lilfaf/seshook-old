import Ember from 'ember';

export default Ember.ArrayController.extend({
  queryParams: ['q'],
  q: null,
  query: Ember.computed.oneWay('q'),
  actions: {
    search: function() {
      Ember.run.debounce(this, function() {
        this.set('q', this.get('query'));
      }, 600);
    }
  }
});
