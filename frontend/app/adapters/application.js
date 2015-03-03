import config from '../config/environment';
import DS from 'ember-data';

export default DS.ActiveModelAdapter.extend({
  namespace: config.apiNamespace,
  host: config.apiHost
});
