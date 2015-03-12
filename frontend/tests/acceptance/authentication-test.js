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

  afterEach(function() {
    FakeServer.shutdown();
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

  it('fails to login with invalid email or password', function() {
    visit('/login');
    fillIn('#identification', 'seshook@email.com');
    fillIn('#password', 'seshook');
    click('button.btn.btn-success');
    andThen(function() {
      expect(find('div.alert.alert-danger').text()).to.have.string('Oh snap! Invalid email or password.');
    });
  });
});

/* TODO Add signup with test helper

it ('signs in user with valid credentials', function() {
  visit('/login');
  fillIn('#email', 'member@email.com');
  fillIn('#password', 'seshook123');
  click('form button');
  andThen(function() {
    expect(currentPath()).to.equal('/');
    expect(find('.navbar-nav a').text()).to.equal('Logout');
  });
}); */

