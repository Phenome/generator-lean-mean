/*global describe, beforeEach, it */
'use strict';
var path = require('path');
var helpers = require('yeoman-generator').test;

describe('lean-mean generator', function () {
  beforeEach(function (done) {
    helpers.testDirectory(path.join(__dirname, 'temp'), function (err) {
      if (err) {
        return done(err);
      }

      this.app = helpers.createGenerator('lean-mean:app', [
        '../../app'
      ]);
      done();
    }.bind(this));
  });

  it('creates expected files', function (done) {
    var expected = [
      // add files you expect to exist here.
      'bower.json',
      'gulpfile.coffee',
      'gulpfile.js',
      'package.json',
      'server.coffee',
      'server.js',
      'backend/middleware.coffee',
      'backend/routes.coffee',
      'backend/config/config.coffee',
      'backend/config/express.coffee',
      'backend/config/env/all.coffee',
      'backend/config/env/development.coffee',
      'backend/config/env/production.coffee',
      'backend/index.coffee',
      'frontend/app.coffee',
      'frontend/index.jade',
      'frontend/modules/main.coffee',
      'frontend/modules/main.jade',
      'frontend/modules/navbar.coffee',
      'frontend/modules/navbar.jade',
      'frontend/styles/main.styl'
    ];

    helpers.mockPrompt(this.app, {
      'appName': 'test',
      'css':['metroui','fontawesome'],
      'scaffolds':['navbar']
    });
    this.app.options['skip-install'] = true;
    this.app.run({}, function () {
      helpers.assertFile(expected);
      done();
    });
  });
});
