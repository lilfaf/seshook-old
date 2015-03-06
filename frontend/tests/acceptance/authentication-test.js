/* jshint expr:true */

import {
  describe,
  it,
  beforeEach,
  afterEach
} from 'mocha';
import { expect } from 'chai';
import Ember from 'ember';
import startApp from '../helpers/start-app';

var App;

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
});

