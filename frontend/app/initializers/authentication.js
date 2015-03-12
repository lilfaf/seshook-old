export function initialize(container) {
  var applicationRoute = container.lookup('route:application');
  var session          = container.lookup('simple-auth-session:main');

  // handle the session events
  session.on('sessionInvalidationSucceeded', function() {
    applicationRoute.transitionTo('index');
  });
}

export default {
  name:  'authentication',
  after: 'simple-auth',
  initialize: initialize
};
