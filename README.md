# generator-lean-mean [![Build Status](https://travis-ci.org/Phenome/generator-lean-mean.svg?branch=master)](https://travis-ci.org/Phenome/generator-lean-mean)

> [Yeoman](http://yeoman.io) generator


## Getting Started

### What is Generator Lean Mean?

After using [generator-angular-fullstack](https://www.npmjs.org/package/generator-angular-fullstack), I searched for a generator that used [Stylus](http://learnboost.github.io/stylus/) and [gulp](http://www.gulpjs.com).

I ended up even preferring the "modular" code organization pattern ([link](https://medium.com/opinionated-angularjs/9f01b594bf06)). I moved some folders around and ended up with a clean generator that uses:

#### The MEAN Stack
* [MongoDB](http://www.mongodb.org/), leading NoSQL database;
* [Express](http://expressjs.com/), for backend routing;
* [AngularJS](https://angularjs.org/), the Superheroic MVW framework for Javascript;
* [Node](http://nodejs.org/), the backend engine that runs on Javascript;

#### Plus these, for personal preferences
* [gulp](http://www.gulpjs.com) for building;
* [Stylus](http://learnboost.github.io/stylus/), for styling;
* [Coffeescript](http://coffeescript.org/), for scripting (frontend and backend!);
* [Jade](http://jade-lang.com/), for templating;

#### The generator will also ask if you want to include
* [Metro UI CSS](http://metroui.org.ua/), a great UI;
OR
* [Bootstrap](http://getbootstrap.com/), which doesn't need introduction;
OR
* [Angular Material](https://material.angularjs.org/#/), A great UI material design library for AngularJs;
* [FontAwesome](http://fortawesome.github.io/Font-Awesome/), for even more icons;
* [MongooseJS](http://mongoosejs.com/), elegant mongodb object modeling for node.js;

And ask if you'd like to include a top Navbar

### Setup
To install generator-lean-mean from npm, run:

```bash
$ npm install -g generator-lean-mean
```

Finally, initiate the generator:

```bash
$ yo lean-mean
```

### Subgenerators
#### front-module

```bash
$ yo lean-mean:front-module
```

Creates an Angular view and controller, and optionally adds it to the Navbar.


### Testing
```bash
$ gulp test:frontend
```

### To Do
* backend testing task;
* Many more subgenerators;


## License

GPL
