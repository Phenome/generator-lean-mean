'use strict';
var fs = require('fs');
var util = require('util');
var yeoman = require('yeoman-generator');


var EndpointGenerator = yeoman.generators.NamedBase.extend({
  constructor: function () {
    yeoman.generators.Base.apply(this, arguments);
    this.config = this.config.getAll();
    this.argument('name',{required:false,desc:"The endpoint name"});
  },
  init: function () {
    var done = this.async(),
      prompts = [];
    if (!this.name)
      prompts.push({
        name: 'name',
        message: 'What this endopoint\'s name ?',
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
  editAppFile: function() {
    console.log('Adding api endpoint on the frontend...')
    var path = "./frontend/app.coffee",
        file = this.readFileAsString(path),
        index = file.indexOf("#---end:endpoints---#");
    if (index === -1) {
      console.log("Could NOT edit file! You'll have to edit it manually. Sorry.");
      return;
    }

    file = file.substring(0, index) +
      "#@include jelbourn.ApiModel\n" +
      "    class " + this._.capitalize(this.name) + " \n" +
      "      afterLoad : ->\n" +
      "        @id = @_id\n" +
      "        delete @_id\n" +
      "      beforeSave : ->\n" +
      "        @_id = @id\n" +
      "        delete @id\n" +
      "    apiProvider.setBaseRoute '/api/'\n" +
      "    apiProvider\n" +
      "      .endpoint '" + this.moduleCamelName + "'\n" +
      "      .route '" + this.moduleCamelName + "/:id'\n" +
      "      .model " + this._.capitalize(this.name) + "\n    " +
      file.substring(index);
    fs.writeFileSync(path,file);
  },
  end: function() {
    console.log('Created endpoint ' + this.name + '.');
  }
});

module.exports = EndpointGenerator;