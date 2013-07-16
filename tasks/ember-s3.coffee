s3 = require 's3'
async = require 'async'

module.exports = (grunt) ->
  ENV = process.env
  # For WHAT is the purpose of uploading versions of files if the version lacks
  # presence!
  commit = ENV.TRAVIS_COMMIT or throw new Error('set a TRAVIS_COMMIT env var')

  # Turn some lovely filename such as dist/1.js into 1-#{commit}.js and
  # 1-latest.js
  fileName = (file) -> file.split('/')[1]
  gitFileName = (file,comm=commit) ->
    baseName = fileName(file).split('.')[0]
    baseName = "#{baseName}-#{comm}"
    baseName + '.' + (file.split('.')[1..]).join('')

  # Give the author convenience and reduce duplication by specifying the
  # upload as a "latest" upload!
  class FileUpload
    constructor: (@src, @fileSuffix = '') ->
      @dest = if @fileSuffix
        gitFileName(@src, @fileSuffix)
      else
        gitFileName(@src)

  # The meat of the matter!
  grunt.registerTask 'ember-s3', ->
    branch = ENV.TRAVIS_BRANCH
    unless branch is 'master'
      grunt.log.ok 'not uploading any files because this is not the master branch'
      return
    client = s3.createClient
      key: ENV.AWS_ACCESS_KEY_ID
      secret: ENV.AWS_SECRET_ACCESS_KEY
      bucket: 'ember-test'

    # Go forth, and grab thee configuration!
    config = grunt.config 'ember-s3'
    files = grunt.file.expand config.files.src
    return unless files.length

    # Transform the files into a format suitable for the upload function!
    uploads = (new FileUpload(file) for file in files)
    # Thou shalt not forget the 'latest' version thou shalt upload for consumer
    # convenience!
    uploads = uploads.concat (new FileUpload(file, 'latest') for file in files)

    done = @async()

    # Upload To S3, whilst notifying the user of thine intent!
    upload = (file, cb) ->
      grunt.log.ok "uploading #{file.src} to #{file.dest}"
      upload = client.upload file.src, file.dest
      upload.on('error', (err)-> cb(err))
      upload.on('end', cb)

    # Process each item asynchronously, and yet sequentially!
    async.eachSeries uploads, upload, done

