
module.exports = (grunt) ->
  module = require './package.json'
  grunt.loadNpmTasks(dep) for dep,_ of module.devDependencies when /grunt-/.test(dep)
  grunt.loadTasks 'tasks'

  grunt.initConfig
    coffee:
      compile:
        expand: true
        ext: '.js'
        src: ['index.coffee','tasks/*.coffee']

    'ember-s3':
      bucketName: 'ember-test'
      prefix: 'studly'

    'npm-publish'
      require: 'coffee:compile'
