Grunt Ember S3
=====

Tasks for uploading various build files to S3.

This task will, given some file (or mulitple files using grunt's file glob
syntax):

* Create a file called fileBaseName-latest.extension
* Create a file called fileBaseName-gitRevision.extension

# Usage

In your `.bashrc` or `.zshrc`:

```bash
export TRAVIS_COMMIT='something-fake' # This will be here on Travis CI.
export TRAVIS_BRANCH='master' # This will be here on Travis CI.
export AWS_ACCESS_KEY_ID='something' # Encrypt this in .travis.yml
export AWS_SECRET_ACECSS_KEY='asdf1234' # Encrypt this in .travis.yml
```

You can read about encrypting environment variables on the
[Travis docs page][travis] about encryption keys.

In your `Gruntfile`:

```javascript
grunt.loadNpmTasks('grunt-ember-s3');
grunt.initConfig({
  'ember-s3':
    src: [ 'dist/*.js' ], // defaults to this
    bucketName: 'ember-test'
});
```

In the `.travis.yml`:

```yml
after_success: 'grunt ember-s3'
```

[travis]: http://about.travis-ci.org/docs/user/encryption-keys/
