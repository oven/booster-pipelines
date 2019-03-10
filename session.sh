#!/usr/bin/env bash
#doitlive commentecho: true
#doitlive prompt: {dir.bold.magenta} ({vcs_branch.cyan}) ᐅ
#doitlive speed: 2

#************************************
#** Heroku Pipelines Demonstration **
#************************************
#
#Ove Gram Nipen <oven@kantega.no>
#
#
:
#
#Let's create a Heroku app, and push it to heroku
heroku apps:create --region eu booster-pipelines-dev
git push heroku

#We should now see an app in the Heroku Dashboard at https://dashboard.heroku.com/apps
#Use the dashboard to open the app in the browser now

:

#
#Let's create a pipeline to support development, staging and production
heroku pipelines:create --app booster-pipelines-dev --stage development booster-pipelines

#
#Create an app for the staging stage and add it to the pipeline

heroku apps:create --region eu booster-pipelines-staging
heroku pipelines:add --app booster-pipelines-staging --stage staging booster-pipelines

#
#Promote the development app to staging
heroku pipelines:promote --app booster-pipelines-dev

#
#The app is now deployed on https://booster-pipelines-staging.herokuapp.com

:

#
#Edit a file and push to development
echo "<img src='unicorn.jpg' width=600>" >> public/index.html

#
#Then commit and push to heroku. You are now pushing to the development version, since heroku apps:create
#created the heroku remote for you, and subsequent calls to heroku apps:create does not overwrite that.

git add . && git commit -m "improve stuff" && git push heroku

#
#Reload https://booster-pipelines-dev.herokuapp.com - You should be able to see your changes.
#Also, reload https://booster-pipelines-staging.herokuapp.com and observe that the changes are not there.
#
#If you're happy with the changes, you can promote the app to staging

heroku pipelines:promote --app booster-pipelines-dev

#
#We're ready to go to production. Let's create a production app
heroku apps:create --region eu booster-pipelines-production
heroku pipelines:add --app booster-pipelines-production --stage production booster-pipelines

#
#And promote the staging app to production
heroku pipelines:promote --app booster-pipelines-staging

#
#*** Connect to github and enable automatic deploys
#
#Bring up the Heroku console, and observe the following banner on top:
#
#"Connect this pipeline to GitHub to enable additional features such as review apps,
#automatic deploys, and Heroku CI"
#
#Click "Connect to GitHub" to do just that. Enter booster-pipelines as the name of the repository to connect
#to, and return to the pipeline view.

:

#***************************
#Enable automatic deployment
#
#Go to the Heroku Dashboard, click the arrow next to "booster-pipelines-dev" and select "Configure automatic deploys...".
#Choose the master branch, and click "Enable Automatic Deploys".
#
#Make a small change to the app and push to github.

echo "html {background-color: lightpink}" >> public/style.css
git add . && git commit -m "it's pink!" && git push origin

#Notice that the heroku console says "Building app". Let's open the app and check our work.
:

#Enable Review Apps
#
#In the Heroku console, click "Enable Review Apps...".
#
#Heroku will ask which app to inherit configuration variables from.
# * Select "booster-pipelines-dev"
# * Check the box next to "Create new review apps for new pull requests automatically".
# * Click "Enable" to save your changes.
#
#Notice the message saying "There are no open pull requests on oven/booster-pipelines".

:

#
#Let's create a review app.
#
#First, we need to create a pull request. We'll start by making a new branch and adding some stuff to it

git checkout -b more-awesome
sed -i '' "s/unicorn\.jpg/cat.jpg/" public/index.html
git add . && git commit -m "Better image" && git push -u origin more-awesome

#
#Now you can create a pull request from your branch.
#
#Visit this URL to create the pull request:
#https://github.com/oven/booster-pipelines/pull/new/more-awesome


#
#Then, head back to the heroku console, where you should find that Heroku is already busy building
#and deploying an app for your pull request.
#
#https://dashboard.heroku.com/pipelines/booster-pipelines

:

#Inspect and review the pull request
#
#Do a code review and merge the pull request
#
# * Heroku will immediately remove the review app.
# * Since you pushed to master, you will also see a progress indicator next to "Building app" in the development stage.
#
#When this is done, you can refresh the development app, and you should see that your changes have been published.

:

#
#
#  ========   That's all, folks! :) ==========
#
#Fork the repo at github oven/heroku-pipelines
#
#Comments to: Ove Gram Nipen <oven@kantega.no>
#
#

