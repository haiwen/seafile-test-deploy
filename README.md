seafile-test-deploy [![Build Status](https://secure.travis-ci.org/haiwen/seafile-test-deploy.png?branch=master)](http://travis-ci.org/haiwen/seafile-test-deploy)
===================

Scripts for setup the seafile test enviroment.

### How to use it

To use it in a project, add the following lines to that project's `.travis.yml` file:

```yaml
before_install:
  # build/init/start ccnet-server/seafile-server
  - git clone --depth=1 --branch=master git://github.com/haiwen/seafile-test-deploy /tmp/seafile-test-deploy
  - cd /tmp/seafile-test-deploy && ./bootstrap.sh && cd -
```

The `bootstrap.sh` would download/build/init/start ccnet-server/seafile-server/fileserver for you.
