#!/bin/bash

if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "this is PR, exiting"
  exit 0
fi

# enable error reporting to the console
set -e 

jekyll build

#clone `master' branch of the repository using encrypted GH_TOKEN for authentification
git clone https://${GH_TOKEN}@github.com/appbaseio/appbaseio.github.io.git ../appbaseio.github.io.master

# copy generated HTML site to `master' branch
cp -R _site/* ../appbaseio.github.io.master

# commit and push generated content to `master' branch
# since repository was cloned in write mode with token auth - we can push there
cd ../appbaseio.github.io.master
git config user.email "appbaseio@gmail.com"
git config user.name "Farhan Chauhan"
git add -A .
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
git push --quiet origin master > /dev/null 2>&1
