gulp = require 'gulp'
gulpFilter = require 'gulp-filter'
uglify = require 'gulp-uglify'
changed = require 'gulp-changed'
gutil = require 'gulp-util'
inject = require 'gulp-inject'
livereload = require 'gulp-livereload'
bowerFiles = require 'gulp-bower-files'
coffee = require 'gulp-coffee'
stylus = require 'gulp-stylus'
nib = require 'nib'
spawn = require('child_process').spawn
node = null

uglifyFilter = gulpFilter ['**/*.js']
bowerFilesFilter = gulpFilter ['**/*.js', '**/*.css']
bowerInjectFilter = gulpFilter ['**/*.min.js', '**/*.css']

gulp.task 'coffee', ->
  gulp
  .src ['frontend/**/*.coffee']
  .pipe changed './.tmp'
  .pipe coffee(bare:true).on 'error', gutil.log
  .pipe gulp.dest './.tmp'

gulp.task 'coffee-and-reload', ['coffee'], ->
  livereload.changed('coffee')

gulp.task 'stylus', ->
  gulp
  .src ['frontend/styles/**/*.styl']
  .pipe changed './.tmp'
  .pipe stylus use:nib(),errors:true
  .pipe gulp.dest './.tmp/styles'

gulp.task 'stylus-and-reload', ['stylus'], ->
  livereload.changed('style')

gulp.task 'spawn', ->
  node.kill() if node
  node = spawn 'node', ['server.js'], stdio:'inherit'
  node.on 'close', (code) ->
    if code is 8
      gutil.log 'Error! Wating for changes'

gulp.task 'livereload-start', ->
  livereload.listen()

gulp.task 'watch-server', ['livereload-start'], ->
  gulp.watch ['server.coffee','backend/**/*.coffee'], ['spawn']
  .on 'change', (file) ->
    livereload.changed file.path

gulp.task 'watch', ['livereload-start'], ->
  livereload.listen()
  gulp.watch ['frontend/**/*.coffee'], ['coffee-and-reload']
  gulp.watch ['frontend/styles/**/*.styl'], ['stylus-and-reload']
  gulp.watch ['frontend/**/*.jade']
  .on 'change', (file) ->
    livereload.changed file.path

gulp.task 'bower-copy', ->
  bowerFiles()
  .pipe gulp.dest 'frontend/lib'


gulp.task 'inject-scripts', ['bower-copy', 'coffee', 'stylus'], ->
  gulp.src ['frontend/lib/**/*', './.tmp/**/*'], read:false
  .pipe inject 'frontend/index.jade',
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

gulp.task 'serve', ['bower-copy', 'inject-scripts', 'spawn', 'watch', 'watch-server'], ->