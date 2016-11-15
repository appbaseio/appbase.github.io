#!/bin/bash

if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "this is PR, exiting"
  exit 0
fi

# enable error reporting to the console
set -e 

python generate.py

#clone `master' branch of the repository using encrypted GITHUB_SECRET_TOKEN for authentification
git clone https://${GITHUB_SECRET_TOKEN}@github.com/appbaseio/appbaseio.github.io.git ../appbaseio.github.io.master

# copy generated HTML site to `master' branch
cp -R ./index.html ./repos.json ./assets/* ./repo_images/* ./bower_components/* ./images/* ../appbaseio.github.io.master

# commit and push generated content to `master' branch
# since repository was cloned in write mode with token auth - we can push there
cd ../appbaseio.github.io.master
git config user.email "appbaseio@gmail.com"
git config user.name "Appbase bot"
git add -A .
git commit -a -m "Travis Build #$TRAVIS_BUILD_NUMBER"
git push https://${GITHUB_SECRET_TOKEN}@github.com/appbaseio/appbaseio.github.io.git master:master > /dev/null 2>&1