/* jshint expr:true */
import {
  describe,
  it,
  before,
  after,
  beforeEach,
  afterEach
} from 'mocha';
import { expect } from 'chai';
import Ember from 'ember';
import startApp from '../helpers/start-app';
import Pretender from 'pretender';

var App;
var FakeServer;

describe('Acceptance: Registration', function() {

  beforeEach(function() {
    App = startApp();
  });

  afterEach(function() {
    Ember.run(App, 'destroy');
  });

  var register = function(email, password, passwordConfirmation) {
    visit('/register');
    fillIn('#email', email);
    fillIn('#password', password);
    fillIn('#password-confirmation', passwordConfirmation);
    click('form button');
  };

  it('can visit registration', function() {
    visit('/register');
    andThen(function() {
      expect(currentPath()).to.equal('register');
    });
  });

  describe('with invalid attributes', function() {
    before(function() {
      var error_payload = {
        errors: {
          email: ["is invalid"],
          password_confirmation: ["doesn't match Password"],
          password: ["is too short (minimum is 8 characters)"]
        }
      };

      FakeServer = new Pretender(function() {
        this.post('/api/users', function(request) {
          return [422, {"Content-Type": "application/json"}, JSON.stringify(error_payload)];
        });
      });
    });

    after(function() {
      FakeServer.shutdown();
    });

    it('fails to register', function() {
      register('notanemail.com', '123', '123456');
      andThen(function() {
        expect(find('#email + .error > span').text()).to.equal('is invalid');
        expect(find('#password + .error > span').text()).to.equal('is too short (minimum is 8 characters)');
        expect(find('#password-confirmation + .error > span').text()).to.equal("doesn't match Password");
        expect(find('form button').is(':disabled')).to.equal(true);
      });
    });
  });

  describe('with valid attributes', function() {
    before(function() {
      var success_payload = {
        access_token: "89c8e6a0447e4bcbaee557a2ffe77562542748c0dc1831b9abb65aff8121c897",
        token_type: "bearer",
        user_id:1
      };

      var user_payload = {
        user: { id: 1, email: "member@email.com" }
      };

      FakeServer = new Pretender(function() {
        this.post('/oauth/token', function(request) {
          return [200, {"Content-Type": "application/json"}, success_payload];
        });

        this.post('/api/users', function(request) {
          return [201, {"Content-Type": "application/json"}, user_payload];
        });
      });

      FakeServer.prepareBody = function(body) {
        return JSON.stringify(body);
      };
    });

    after(function() {
      FakeServer.shutdown();
    });

    it('register user successfully', function() {
      register('member@email.com', 'seshook123', 'seshook123');
      andThen(function() {
        expect(currentPath()).to.equal('index');
        expect(find('#title').text()).to.equal('Fuck yeah! Your are signed in as member@email.com!');
      });
    });
  });
});
