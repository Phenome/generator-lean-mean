gulp = require 'gulp'
p = require('gulp-load-plugins')() # loading gulp plugins lazily
bowerFiles = require 'main-bower-files'
nib = require 'nib'
es = require 'event-stream'
spawn = require('child_process').spawn
node = null

gulp.task 'build', ['coffee', 'stylus'], ->
  jsFilter = p.filter ['*.js']
  cssFilter = p.filter ['*.css']
  extraFilter = p.filter ['!*.js', '!*.css', '!*.coffee']
  es.concat(
      gulp
      .src './.tmp/**/*.js'
      .pipe p.concat 'scripts.js'
      .pipe p.uglify(mangle:false).on 'error', (err)->p.util.log err;@emit 'end'
      .pipe gulp.dest './build/frontend/js/'
    ,
      gulp.src bowerFiles()
      .pipe jsFilter
      .pipe p.concat 'bower.js'
      .pipe p.uglify mangle:true
      .pipe gulp.dest './build/frontend/js/'
    ,
      gulp.src bowerFiles()
      .pipe extraFilter
      .pipe gulp.dest './build/frontend/fonts/'
    ,
      gulp.src bowerFiles()
      .pipe cssFilter
      .pipe p.concat 'bower.css'
      .pipe p.minifyCss().on 'error', (err)->p.util.log err;@emit 'end'
      .pipe gulp.dest './build/frontend/css/'
    ,
      gulp.src './.tmp/**/*.css'
      .pipe p.concat 'style.css'
      .pipe p.minifyCss().on 'error', (err)->p.util.log err;@emit 'end'
      .pipe gulp.dest './build/frontend/css/'
    ,
      gulp.src ['./frontend/**/*.jade', './frontend/resources/*']
      .pipe gulp.dest './build/frontend/'
    ,
      gulp.src ['./server.*']
      .pipe gulp.dest './build/'
    ,
      gulp.src ['./backend/**/*.coffee']
      .pipe gulp.dest './build/backend/'
  ) 

gulp.task 'coffee', ->
  gulp
  .src ['frontend/**/*.coffee','!frontend/bower_components/**/*']
  .pipe p.changed './.tmp', extension:'.js'
  .pipe p.coffee(bare:true).on 'error', (err)->p.util.log err;@emit 'end'
  .pipe gulp.dest './.tmp'

gulp.task 'coffee-backend', ->
  gulp
  .src ['backend/models/*.coffee']
  .pipe p.changed './.tmp/backend/models', extension:'.js'
  .pipe p.coffee(bare:true).on 'error', (err)->p.util.log err;@emit 'end'
  .pipe gulp.dest './.tmp/backend/models'

gulp.task 'stylus', ->
  gulp
  .src ['frontend/styles/**/*.styl','!frontend/bower_components/**/*']
  .pipe p.changed './.tmp'
  .pipe p.stylus(use:[nib()]).on 'error', (err)->p.util.log "Stylus Error:\n#{err.message}";@emit 'end'
  .pipe gulp.dest './.tmp/styles'

gulp.task 'spawn', ['coffee-backend'], ->
  node.kill() if node
  node = spawn 'node', ['server.js'], stdio:'inherit'
  node.on 'close', (code) ->
    if code is 8
      p.util.log 'Error! Wating for changes'

gulp.task 'livereload-start', ->
  p.livereload.listen()

gulp.task 'watch-server', ['livereload-start'], ->
  gulp.watch ['backend/models/**/*.coffee'], ['coffee-backend']
  gulp.watch ['server.coffee','backend/**/*.coffee', '.tmp/backend/**/*.js', "backend/models/**/*"], ['spawn']
  .on 'change', (file) ->
    p.livereload.changed file.path

gulp.task 'watch', ['livereload-start'], ->
  gulp.watch ['frontend/**/*.coffee'], ['coffee']
  gulp.watch ['frontend/styles/**/*.styl'], ['stylus']
  gulp.watch ['frontend/**/*.jade', './.tmp/**/*', '!./.tmp/backend/**/*']
  .on 'change', (file) ->
    p.livereload.changed file.path

gulp.task 'inject-bower', ->
  gulp.src bowerFiles()
  .pipe p.inject 'frontend/index.jade',
    starttag:'//---inject:bower:{{ext}}---'
    endtag:'//---inject---'
    transform: (filepath, file, index, length) ->
      filepath = filepath.replace /^.+?\//, '' #removes frontend/, .tmp/
      ext = filepath.split('.').pop()
      switch ext
        when 'css'
          "link(rel='stylesheet' href='#{filepath}')"
        when 'js'
          "script(src='#{filepath}')"
  .pipe gulp.dest 'frontend'

gulp.task 'inject-libs', ['coffee'], ->
  gulp.src './.tmp/lib/**/*', read:false
  .pipe p.inject 'frontend/index.jade',
    starttag:'//---inject:lib:{{ext}}---'
    endtag:'//---inject---'
    transform: (filepath, file, index, length) ->
      filepath = filepath.replace /^.+?\//, '' #removes frontend/, .tmp/
      ext = filepath.split('.').pop()
      switch ext
        when 'css'
          "link(rel='stylesheet' href='#{filepath}')"
        when 'js'
          "script(src='#{filepath}')"
  .pipe gulp.dest 'frontend'

gulp.task 'inject-scripts', ['coffee', 'stylus', 'inject-bower', 'inject-libs'], ->
  gulp.src ['./.tmp/**/*', '!./.tmp/backend/**/*', '!./.tmp/lib/**'], read:false
  .pipe p.inject 'frontend/index.jade',
    starttag:'//---inject:{{ext}}---'
    endtag:'//---inject---'
    transform: (filepath, file, index, length) ->
      filepath = filepath.replace /^.+?\//, '' #removes frontend/, .tmp/
      ext = filepath.split('.').pop()
      switch ext
        when 'css'
          "link(rel='stylesheet' href='#{filepath}')"
        when 'js'
          "script(src='#{filepath}')"
  .pipe gulp.dest 'frontend'

gulp.task 'serve', ['inject-scripts', 'coffee-backend', 'spawn', 'watch', 'watch-server'], ->