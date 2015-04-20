import FacebookAuthenticator from '../utils/facebook-authenticator';

export function initialize(container) {
  var torii = container.lookup('torii:main');
  var authenticator = FacebookAuthenticator.create({
    torii: torii
  });
  container.register('authenticator:facebook', authenticator, {
    instantiate: false
  });
}

export default {
  name: 'simple-auth-config',
  before: 'simple-auth',
  after: 'torii',
  initialize: initialize
};
