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
import Pretender from 'pretender';

var App;

describe('Acceptance: Profile', function() {

  beforeEach(function() {
    App = startApp();
  });

  afterEach(function() {
    Ember.run(App, 'destroy');
  });

  describe('when not signed in', function() {

    it('cannot visit profile', function() {
      visit('/profile');
      andThen(function() {
        expect(currentPath()).to.equal('login');
      });
    });
  });

  it('can visit profile', function() {
    authenticateSession();
    visit('/profile');
    andThen(function() {
      click('.dropdown-menu a:first');
      andThen(function() {
        expect(find('#title').text()).to.equal('Edit your profile');
        expect(currentPath()).to.equal('profile');
        invalidateSession();
      });
    });
  });
});

  //describe('with invalid attributes', function() {
  //  before(function() {
  //    FakeServer = new Pretender(function() {
  //      var error_payload = { errors: { email: ["is invalid"] } };
  //      this.put('/api/users/1', function(request) {
  //        return [422, {"Content-Type": "application/json"}, JSON.stringify(error_payload)];
  //      });
  //    });
  //  });
//
  //  it('fails to update user profile', function() {
  //    authenticateSession();
  //    updateProfile({'email': 'notvalidemail'});
  //    andThen(function() {
  //      expect(find('#email + .error > span').text()).to.equal('is invalid');
  //      FakeServer.shutdown();
  //      invalidateSession();
  //    });
  //  });
  //});

  //describe('with valid attributes', function() {
  //  before(function() {
  //    FakeServer = new Pretender(function() {
  //      var user_payload = { user: { id: 1, email: 'member@email.com'} };
  //      this.put('/api/users/1', function(request) {
  //        return [200, { "Content-Type": "appication/json"}, JSON.stringify(user_payload)];
  //      });
  //    });
  //  });
//
  //  it('updates user profile', function() {
  //    updateProfile({'email': 'new@email.com'});
  //    andThen(function() {
  //      expect(find('.alert-success').text()).to.equal('Yey! Your profile was updated successfully.');
  //      FakeServer.shutdown();
  //    });
  //  });
  //});
