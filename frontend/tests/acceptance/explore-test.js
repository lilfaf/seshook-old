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

describe('Acceptance: Explore', function() {
  beforeEach(function() {
    App = startApp();
  });

  afterEach(function() {
    Ember.run(App, 'destroy');
  });

  describe('when not signed in', function() {
    it('cannot visit explore', function() {
      invalidateSession();
      visit('/explore');
      andThen(function() {
        expect(currentPath()).to.equal('login');
      });
    });
  });

  describe('when signed in', function() {
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

    //it('can visit profile', function() {
    //  visit('/');
    //  andThen(function() {
    //    click('#explore');
    //    andThen(function() {
    //      expect(currentPath()).to.equal('explore');
    //      expect(find('li.active')).to.exist;
    //    });
    //  });
    //});
  });
});
