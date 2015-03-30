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
var FakeServer;

describe('Acceptance: Profile', function() {
  beforeEach(function() {
    App = startApp();
  });

  afterEach(function() {
    Ember.run(App, 'destroy');
  });

  describe('when not signed in', function() {
    it('cannot visit profile', function() {
      invalidateSession();
      visit('/profile');
      andThen(function() {
        expect(currentPath()).to.equal('login');
      });
    });
  });

  describe('when signed in', function() {

    // a helper method to update the profile
    var updateProfile = function(attributes) {
      visit('/profile');
      fillIn('#email', attributes['email']);
      click('form button');
    };

    beforeEach(function() {
      var user_payload = {user: {id: 1, email: 'member@email.com'}};

      FakeServer = new Pretender(function() {
        this.get('/api/users/1', function(request) {
          return [200, {"Content-Type": "application/json"}, JSON.stringify(user_payload)];
        });
      });

      authenticateSession();
      Ember.run(function(){
        currentSession().set('user_id', 1);
      });
    });

    afterEach(function() {
      invalidateSession();
      FakeServer.shutdown();
    });

    it('can visit profile', function() {
      visit('/');
      andThen(function() {
        click('#profile');
        andThen(function() {
          expect(currentPath()).to.equal('profile');
          expect(find('h2:first').text()).to.equal('Change your avatar');
          expect(find('h2:last').text()).to.equal('Edit your informations');
        });
      });
    });

    describe('with invalid attributes', function() {
      var email = 'wesh@email.com';

      beforeEach(function() {
        var user_payload = {user: {id: 1, email: email}};
        FakeServer = new Pretender(function() {
          this.put('/api/users/1', function(request) {
            return [200, {"Content-Type": "application/json"}, JSON.stringify(user_payload)];
          });
        });
      });

      it('updates successfully', function() {
        updateProfile({email: email});
        andThen(function() {
          expect(currentPath()).to.equal('profile');
          expect(find('#email').val()).to.equal(email);
          expect(find('.alert-success').text()).to.have.string('Yey! Your profile was updated successfully.');
        });
      });
    });

    describe('with invalid attributes', function() {
      beforeEach(function() {
        var error_payload = {errors: {email: ["is invalid"]}};

        FakeServer = new Pretender(function() {
          this.put('/api/users/1', function(request) {
            return [422, {"Content-Type": "application/json"}, JSON.stringify(error_payload)];
          });
        });
      });

      it('fails to update', function() {
        updateProfile({email: 'notvalidemail'});
        andThen(function() {
          expect(find('#email + .error > span').text()).to.equal('is invalid');
        });
      });
    });
  });
});
