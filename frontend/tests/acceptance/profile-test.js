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
import register from '../helpers/register-helper';

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
    visit('/');
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
