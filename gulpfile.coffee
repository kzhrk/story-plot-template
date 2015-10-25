gulp        = require 'gulp'
server      = require 'gulp-webserver'
concat      = require 'gulp-concat'
markdown    = require 'gulp-markdown'
data        = require 'gulp-data'
template    = require 'gulp-template'
runSecuence = require 'gulp-run-sequence'
fs          = require 'fs'

gulp.task 'watch', ->
  gulp.watch './src/**/*', ['sequence']

gulp.task 'server', ->
  gulp
    .src './public'
    .pipe server(
      livereload: true
      port: 9001
    )

gulp.task 'sequence', ->
  runSecuence 'markdown', 'publish'

gulp.task 'markdown', ->
  gulp
    .src './src/acts/*.md'
    .pipe concat('index.md')
    # .pipe markdown()
    .pipe gulp.dest('./public/acts')
  gulp
    .src './src/characters/*.md'
    .pipe concat('index.md')
    # .pipe markdown()
    .pipe gulp.dest('./public/characters')
  gulp
    .src './src/parts/*.md'
    .pipe concat('index.md')
    # .pipe markdown()
    .pipe gulp.dest('./public/parts')

gulp.task 'publish', ->
  gulp
    .src './src/index.md'
    .pipe data ()->
      {
        acts      : fs.readFileSync('./public/acts/index.md')
        characters: fs.readFileSync('./public/characters/index.md')
        parts     : fs.readFileSync('./public/parts/index.md')
      }
    .pipe template()
    .pipe markdown()
    .pipe gulp.dest('./public')

gulp.task 'default', ['sequence', 'server', 'watch']
