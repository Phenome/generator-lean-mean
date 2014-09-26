'use strict';
var fs = require('fs');
var util = require('util');
var yeoman = require('yeoman-generator');


var BackModuleGenerator = yeoman.generators.NamedBase.extend({
  constructor: function () {
    yeoman.generators.Base.apply(this, arguments);
    this.config = this.config.getAll();
    this.argument('name',{required:false,desc:"The module name"});
  },
  init: function () {
    var done = this.async(),
      prompts = [];
    if (!this.name)
      prompts.push({
        name: 'name',
        message: 'What this module\'s name ?',
        validate: function (answer) {
          if (!answer)
            return "I need a name, Sir!";
          return true;
        }
      });
    if (prompts.length > 0) {
      this.prompt(prompts, function (props) {
        this.name = this.name || props.name;
        done();
      }.bind(this));
    } else done();
  },

  files: function () {
    this.appName = this.config.appName;
    this.moduleCamelName = this.name[0].toLowerCase() + this.name.substring(1);
    this.moduleCamelName = this._.camelize(this.moduleCamelName);
    this.moduleName = this._.camelize("-"+this.name);

    this.template("module.coffee", "backend/modules/"+this.moduleCamelName+".coffee");
  },
  end: function() {
    console.log('Created module ' + this.name + '.');
  }
});

module.exports = BackModuleGenerator;