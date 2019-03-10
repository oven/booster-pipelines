#!/usr/bin/env bash

heroku pipelines:destroy booster-pipelines
heroku apps:destroy booster-pipelines-dev --confirm booster-pipelines-dev
heroku apps:destroy booster-pipelines-staging --confirm booster-pipelines-staging
heroku apps:destroy booster-pipelines-production  --confirm booster-pipelines-production

git checkout master
git reset --hard START
git push --force origin master
git branch -D more-awesome
git push origin :more-awesome

