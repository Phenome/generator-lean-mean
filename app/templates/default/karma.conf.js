module.exports = function(config) {
  'use strict';
  config.set({
    // base path, that will be used to resolve files and exclude
    basePath: '',

    // testing framework to use (jasmine/mocha/qunit/...)
    frameworks: ['jasmine'],

    // list of files / patterns to load in the browser
    files: [
      'frontend/bower_components/angular/angular.js',
      'frontend/bower_components/angular-mocks/angular-mocks.js',
      'frontend/bower_components/angular-resource/angular-resource.js',
      'frontend/bower_components/angular-cookies/angular-cookies.js',
      'frontend/bower_components/angular-sanitize/angular-sanitize.js',
      'frontend/bower_components/angular-route/angular-route.js',
      'frontend/bower_components/angular-animate/angular-animate.js',<% if (config.css === 'AngularMaterial') { %>
      'frontend/bower_components/angular-material/angular-material.js',
      'frontend/bower_components/angular-aria/angular-aria.js',<% } %>
      'frontend/app.coffee',
      'frontend/modules/**/*.coffee',
      'frontend/modules/**/*.jade',
    ],

    preprocessors: {
      '**/*.jade': 'ng-jade2js',
      '**/*.coffee': 'coffee',
    },

    ngJade2JsPreprocessor: {
      stripPrefix: 'frontend/'
    },

    // list of files / patterns to exclude
    exclude: [],

    // web server port
    port: 8080,

    // level of logging
    // possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
    logLevel: config.LOG_INFO,


    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: false,


    // Start these browsers, currently available:
    // - Chrome
    // - ChromeCanary
    // - Firefox
    // - Opera
    // - Safari (only Mac)
    // - PhantomJS
    // - IE (only Windows)
    browsers: ['PhantomJS'],


    // Continuous Integration mode
    // if true, it capture browsers, run tests and exit
    singleRun: false
  });
};
