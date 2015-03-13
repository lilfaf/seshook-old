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

describe('Acceptance: Authentication', function() {
  beforeEach(function() {
    App = startApp();
  });

  afterEach(function() {
    Ember.run(App, 'destroy');
  });

  it('display login and register links', function() {
    visit('/');
    expect(find('.navbar-nav a:first').text()).to.equal('Register');
    expect(find('.navbar-nav a:last').text()).to.equal('Login');
  });

  it('display welcome message', function() {
    visit('/');
    expect(find('#title').text()).to.equal('Please try to sign in!');
  });

  it('login links redirect to /login', function() {
    visit('/');
    click('.navbar-nav a:last');
    andThen(function() {
      expect(currentPath()).to.equal('login');
    });
  });

  describe('with invalid credentials', function() {
    before(function() {
      var error_payload = {
        error: "invalid_grant",
        error_description: "Invalid email or password."
      };

      FakeServer = new Pretender(function() {
        this.post('/oauth/token', function(request) {
          return [401, {"Content-Type": "application/json"}, JSON.stringify(error_payload)];
        });
      });
    });

    after(function() {
      FakeServer.shutdown();
    });

    it('fails to login', function() {
      visit('/login');
      fillIn('#identification', 'unknown@email.com');
      fillIn('#password', '123');
      click('button.btn.btn-success');
      andThen(function() {
        expect(currentPath()).to.equal('login');
        expect(find('div.alert.alert-danger').text()).to.have.string('Oh snap! Invalid email or password.');
      });
    });
  });

  describe('with valid credentials', function() {
    before(function() {
      var success_payload = {
        access_token: "89c8e6a0447e4bcbaee557a2ffe77562542748c0dc1831b9abb65aff8121c897",
        token_type: "bearer",
        expires_in:7200,
        created_at:1426125577,
        user_id:1
      };

      var user_payload = {
        user: { id: 1, email: "member@email.com" }
      };

      FakeServer = new Pretender(function() {
        this.post('/oauth/token', function(request) {
          return [200, {"Content-Type": "application/json"}, success_payload];
        });

        this.post('/oauth/revoke', function(request) {
          return [200, {"Content-Type": "application/json"}, null];
        });

        this.get('/api/users/1', function(request) {
          return [200, {"Content-Type": "application/json"}, user_payload];
        });
      });

      FakeServer.prepareBody = function(body) {
        return body ? JSON.stringify(body) : '{}';
      };
    });

    after(function() {
      FakeServer.shutdown();
    });

    beforeEach(function() {
      visit('/login');
      fillIn('#identification', 'member@email.com');
      fillIn('#password', 'seshook123');
      click('form button');
    });

    it('logs in successfully', function() {
      expect(currentPath()).to.equal('index');
      expect(find('.navbar-nav a').text()).to.equal('Logout');
      expect(find('#title').text()).to.equal('Fuck yeah! Your are signed in as member@email.com!');
    });

    it('logs out', function() {
      click('.navbar-nav a');
      andThen(function() {
        expect(currentPath()).to.equal('index');
        expect(find('.navbar-nav a:last').text()).to.equal('Login');
      });
    });
  });
});
