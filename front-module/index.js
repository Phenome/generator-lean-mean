 'use strict';
var util = require('util');
var yeoman = require('yeoman-generator');


var FrontModuleGenerator = yeoman.generators.NamedBase.extend({
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
    if (this.config.scaffolds.indexOf('navbar') >= 0)
      prompts.push({
        type:'confirm',
        name: 'addToNavbar',
        message: 'Add this module to the navbar?'
      });
    if (prompts.length > 0) {
      this.prompt(prompts, function (props) {
        this.name = this.name || props.name;
        this.addToNavbar = props.addToNavbar ? props.addToNavbar : false;
        done();
      }.bind(this));
    } else done();
  },

  files: function () {
    this.appName = this.config.appName;
    this.moduleCamelName = this.name[0].toLowerCase() + this.name.substring(1);
    this.moduleCamelName = this._.camelize(this.moduleCamelName);
    this.moduleName = this._.camelize("-"+this.name);

    this.template("controller.coffee", "frontend/modules/"+this.moduleCamelName+".coffee");
    this.template("view.jade", "frontend/modules/"+this.moduleCamelName+".jade");
  },
  editNavFile: function() {
    if (!this.addToNavbar)
      return;
    console.log('Editing NavbarCtrl...')
    var path = "./frontend/modules/navbar.coffee",
        file = this.readFileAsString(path),
        index = file.indexOf("#---end:modules---#");
    if (index === -1) {
      console.log("Could NOT edit file! You'll have to edit it manually. Sorry.");
      return;
    }
    file = file.substring(0, index) +
      ",\n    name: \"" + this._.capitalize(this.name) + "\"\n" +
      "    path: \"/" + this.moduleCamelName + "\"\n   " +
      file.substring(index);
    this.write(path, file);
  },
  end: function() {
    console.log('Created module ' + this.name + '.');
  }
});

module.exports = FrontModuleGenerator;