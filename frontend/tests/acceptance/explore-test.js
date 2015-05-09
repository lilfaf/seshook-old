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
      var search_payload = {
        spots:[{
            id: 6,
            name: null,
            latlon:[48.84116666666667,2.3673333333333333],
            address_id: 1,
            user_id: null
          }
        ],
        addresses:[
          {
            id: 1,
            street: 'Passage Alexendre Prince',
            zip: '75013',
            city: 'Paris',
            state: 'Île-de-France',
            country: 'France'
          }
        ],
        meta:{
          next_page: null,
          prev_page: null,
          current_page: 1,
          total_pages: 1,
          total_count: 1
        }
      };

      FakeServer = new Pretender(function() {
        this.get('/api/users/1', function(request) {
          return [200, {"Content-Type": "application/json"}, JSON.stringify(user_payload)];
        });

        this.get('/api/spots', function(request) {
          return [200, {"Content-Type": "application/json"}, JSON.stringify(search_payload)];
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
        click('#explore');
        andThen(function() {
          expect(currentPath()).to.equal('explore');
          expect(find('li.active')).to.exist;
        });
      });
    });
  });
});
