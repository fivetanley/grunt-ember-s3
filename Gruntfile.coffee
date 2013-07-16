
module.exports = (grunt) ->
  grunt.loadNpmTasks 'coffee'
  grunt.loadTasks 'tasks'

  grunt.initConfig
    coffee:
      ext: '.js'
      src: '*.coffee'
