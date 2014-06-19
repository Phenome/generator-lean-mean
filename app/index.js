'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');
var chalk = require('chalk');
 
var OnepageGenerator = yeoman.generators.Base.extend({
  promptUser: function() {
    var done = this.async();

    // have Yeoman greet the user
    console.log(this.yeoman);

    var prompts = [{
      name: 'appName',
      message: 'What is your app\'s name ?',
      default:  this.arguments[0] || this.appname
    }, {
      name:"css",
      message:"Choose CSSs to add",
      type:"checkbox",
      choices: [
        {
          name: "MetroUI",
          value: 'metroui',
          disabled: function(answers) {
            return answers.indexOf('bootstrap') == -1
          },
          checked: true
        },
        {
          name: "Bootstrap",
          value: 'bootstrap',
          disabled: function(answers) {
            return answers.indexOf('metroui') == -1
          }
        },

        {
          name: "FontAwesome",
          value: 'fontawesome',
          checked: true
        }
      ],
      validate: function(answer) {
        if (answer.indexOf('metroui') >= 0 && answer.indexOf('bootstrap') >= 0)
          return "Sorry. Choose either MetroUI or Bootstrap. You can't pick both.";
        return true;
      }
    }, {
      name:"scaffolds",
      message:"Jumpstart with these elements",
      type:"checkbox",
      choices: [
        {name:"Navbar",value:"navbar",checked:true}
      ]
    }];

    this.prompt(prompts, function (props) {
      this.appName = props.appName;
      this.config.set({
        appName:this.appName,
        scaffolds:props.scaffolds,
        css:props.css
      });
      done();
    }.bind(this));
  },
  saveConfig: function() {
    this.config.save();
  },
  scaffoldFolders: function () {
    this.mkdir("frontend");
    this.mkdir("frontend/modules");
    this.mkdir("frontend/resources");
    this.mkdir("frontend/styles");
    this.mkdir("backend/config");
    this.mkdir("backend/config/env");
    this.mkdir("backend/modules");
  },
  copyMainFiles : function() {
    this.config = this.config.getAll();
    this.directory("default", "/");

    if (this.config.scaffolds.indexOf('navbar') >= 0) {
      this.copy("optional/frontend/modules/navbar.coffee","frontend/modules/navbar.coffee");
      this.copy("optional/frontend/modules/navbar.jade","frontend/modules/navbar.jade");
    }
  },
  runNpm: function(){
    if (this.options['skip-install'])
      return;
    var done = this.async();
    console.log("\nRunning NPM Install. Bower is next.\n");
    this.npmInstall("", function(){
      done();
    });
  },
  runBower: function() {
    if (this.options['skip-install'])
      return; 
    var done = this.async();
    console.log("\nRunning Bower:\n");
    this.bowerInstall("", function(){
      console.log("\nAll set! Type: gulp serve\n");
      done();
    });
  }
});
 
module.exports = OnepageGenerator;